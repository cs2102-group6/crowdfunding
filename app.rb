require 'sinatra'
require 'pg'
require 'bcrypt'
require 'sinatra/flash'

# Require your files here
require_relative './helpers/users.rb'
require_relative './helpers/utils.rb'
require_relative './helpers/projects.rb'


# Register your modules here to make their methods available for use
helpers Users, Utils, Projects

enable :sessions

dbconfig = {
    dbname: 'postgres',
    host: 'localhost',
    port: '5432',
    user: 'postgres',
    password: 'password'
}
$db = PG::Connection.open(dbconfig)

error 401 do
    # Display login page if we send HTTP 401 Not Authorized to the user
    erb :login
end

get '/' do
    # Require user to be authenticated to access the homepage
    require_authenticated # Method defined in ./helpers/utils.rb

    # Fetch ALL the projects
    # Check ./views/index.erb to see how to display the result
    @res = $db.exec("SELECT * FROM projects") # Variables with @ can be accessed from the erb
    erb :index
end

get '/viewProjectDetails' do
    require_authenticated
    @details = $db.exec("SELECT * FROM projects WHERE id=#{params[:projectId]}")
    @currentAmt = $db.exec("SELECT SUM(amount) FROM funds WHERE project_id=#{params[:projectId]}")
    @user = $db.exec("SELECT * FROM users d, projects f WHERE f.id=#{params[:projectId]} AND d.email = f.creator_email")
    erb :projectDetails
end

post '/createProject' do
    erb :projects
end

post '/createSQLProj' do
    begin
        create_project(session[:email])
        flash.next[:createSQLProj] = 'Project successfully created'
    rescue
        flash.next[:createSQLProj] = 'Unable to create project'
    end
end

get '/viewUserProjects' do
    require_authenticated
    @details = $db.exec("SELECT * FROM projects WHERE creator_email=#{session[:email]}")
    erb :projectDetails
end

# Login routes
post '/register' do
    params[:password] = BCrypt::Password.create(params[:password]).to_s
    process_input(params)
    begin
        create_user
        flash.next[:register] = 'Account successfully created'
    rescue
        flash.next[:register] = 'Something went wrong'
    end
    redirect '/'
end

post '/login' do
    input_password = params[:password]
    email = params[:email]
    process_input(params)

    res = find_user
    if res.values.length != 0 # User exists

        # res[0]['password'] obtains the 'password' value in the first row
        stored_hash = res[0]['password']

        restored_password = BCrypt::Password.new(stored_hash)
        if restored_password == input_password
            session[:email] = email
            redirect '/'
        end
    end
    flash.next[:login] = 'Incorrect email/password'
    redirect '/'
end

post '/logout' do
    session.clear
    redirect '/login'
end

get '/login' do
    if session[:email]
        redirect '/'
    else
        erb :login 
    end
end
# End of login routes



