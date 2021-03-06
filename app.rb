require 'sinatra'
require 'pg'
require 'bcrypt'
require 'sinatra/flash'
require 'pry'

# Require your files here
require_relative './helpers/users.rb'
require_relative './helpers/utils.rb'
require_relative './helpers/projects.rb'
require_relative './helpers/funds.rb'


# Register your modules here to make their methods available for use
helpers Users, Utils, Projects, Funds

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
    
    searchStr = params[:search]

    if searchStr.nil? || searchStr.empty?
        @res = $db.exec("SELECT * FROM projects")
    else
        @res = $db.exec("SELECT * FROM projects p
                        WHERE p.title LIKE '%#{searchStr}%' 
                        OR p.description LIKE '%#{searchStr}%'")
    end
    erb :index
end

get '/viewProjectDetails' do
    require_authenticated
    @details = $db.exec("SELECT * FROM projects p WHERE p.project_id=#{params[:projectId]}")
    @currentAmt = $db.exec("SELECT SUM(amount) FROM funds f WHERE f.project_id=#{params[:projectId]}")
    @user = $db.exec("SELECT * FROM users d, projects f WHERE f.project_id=#{params[:projectId]} AND d.email = f.creator_email")
    erb :projectDetails
end

post '/contributeFunds' do  
    begin     
        create_funds
        flash.next[:contributeFunds] = 'Project successfully funded'

    rescue
        flash.next[:contributeFunds] = 'Unable to fund project'
    end
    redirect back
end

get '/createProject' do
    require_authenticated
    erb :createProject
end

# Call SQL to create project in db
post '/createProject' do
    begin
        create_project
        flash.next[:createProject] = 'Project successfully created'
    rescue
        flash.next[:createProject] = 'Unable to create project'
    end
    redirect '/createProject'
end

get '/viewUserProjects' do
    require_authenticated
    # @details = $db.exec("SELECT * FROM projects WHERE creator_email='#{session[:email]}'")
    # @currentAmt = $db.exec("SELECT sum(f.amount) as sum, f.project_id FROM funds f WHERE user_email='#{session[:email]}' GROUP BY f.project_id")
    @details = $db.exec(
        "SELECT p.project_id, p.title, sum(f.amount), p.goal, p.start_date, p.end_date
        FROM projects p
        LEFT JOIN funds f ON p.project_id = f.project_id
        WHERE creator_email='#{session[:email]}'
        GROUP BY p.project_id
        ORDER BY p.project_id"
    )
    erb :viewUserProjects
end

get '/updateProjectDetails' do
    session[:projectId] = params[:projectId]
    @details = $db.exec("SELECT * FROM projects p WHERE p.project_id=#{params[:projectId]}")
    @currentAmt = $db.exec("SELECT SUM(amount) FROM funds f WHERE f.project_id=#{params[:projectId]}")
    erb :updateProject
end

post '/deleteProject' do
    begin
        # delete_project(params[:projectId])
        $db.exec("DELETE FROM projects p WHERE p.project_id=#{params[:projectId]}")
        flash.next[:deleteProject] = 'Project successfully deleted'
    rescue
        flash.next[:deleteProject] = 'Unable to delete project'
    end
    redirect '/viewUserProjects'
end

post '/updateProjectDetails' do
    id = session[:projectId]
    begin
        update_project(id)
        session.delete(:projectId)
        flash.next[:updateProjectDetails] = 'Project successfully updated'
    rescue
        session.delete(:projectId)
        flash.next[:updateProjectDetails] = 'Unable to update project'
    end
    redirect '/'
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
            session[:isadmin] = res[0]['is_admin']
            if res[0]['is_admin'] == 't'
                redirect '/admin'
            else
                redirect '/'
            end
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

#admin routes
get '/admin' do
    if session[:email]
        if session[:isadmin] == 't'
            erb :admin
        else
            redirect "/"
        end
    else
        redirect "/login"
    end
end

post '/createAdmin' do
    require_admin_authenticated
    params[:password] = BCrypt::Password.create(params[:password]).to_s
    process_input(params)
    begin
        create_admin
        flash.next[:createAdmin] = 'Account successfully created'
    rescue
        flash.next[:createAdmin] = 'An error occured!'
    end
    redirect '/admin'
end

get '/editProjectDetails' do
    require_admin_authenticated
    @details = $db.exec("SELECT * FROM projects p WHERE p.project_id=#{params[:projectId]}")
    @currentAmt = $db.exec("SELECT SUM(amount) FROM funds f WHERE f.project_id=#{params[:projectId]}")
    @user = $db.exec("SELECT * FROM users d, projects f WHERE f.project_id=#{params[:projectId]} AND d.email = f.creator_email")
    erb :editProjectDetails
end

post '/adminUpdatenProjectDetails' do
    require_admin_authenticated
    begin
        admin_update_project
        flash.next[:updateProjectDetails] = 'Project details successfully updated'
    rescue
        flash.next[:updateProjectDetails] = 'An error occured!'
    end
    redirect '/admin'
end

get '/deleteProject' do
    require_admin_authenticated
    begin
        delete_project
        flash.next[:deleteProjectDetails] = 'Project details successfully deleted'
    rescue
        flash.next[:deleteProjectDetails] = 'An error occured!'
    end
    redirect '/admin'
end
#End of admin routes

get '/changePassword' do
    erb :changePassword
end

post '/changePassword' do
    #  binding.pry
    # input_password = params[:old_password]
    params[:new_password] = BCrypt::Password.create(params[:new_password]).to_s
    process_input(params)
    
    begin
        # chk_password = $db.exec("SELECT u.password FROM users u WHERE email='#{session[:email]}'")
        # stored_hash = chk_password[0]['password']

        # restored_password = BCrypt::Password.create(stored_hash)
        
        # if input_password == restored_password
            change_password
            flash.next[:changePassword] = 'Password change successfully'
        # else
        #     flash.next[:changePassword] = 'Wrong old password'
        # end
    rescue
        flash.next[:changePassword] = 'An error occured!'
    end
    redirect '/changePassword'
    
end
