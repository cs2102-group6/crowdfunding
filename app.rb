require 'sinatra'
require 'pg'
require 'bcrypt'

# Require your files here
require_relative './helpers/users.rb'
require_relative './helpers/utils.rb'

# Register your modules here to make their methods available for use
helpers Users, Utils

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

# Login routes
post '/register' do
    params[:password] = BCrypt::Password.create(params[:password]).to_s
    process_input(params)
    create_user
    redirect '/'
end

post '/login' do
    input_password = params[:password]
    process_input(params)

    res = find_user
    if res.values.length != 0 # User exists

        # res[0]['password'] obtains the 'password' value in the first row
        stored_hash = res[0]['password']

        restored_password = BCrypt::Password.new(stored_hash)
        if restored_password == input_password
            session[:authenticated] = true
            redirect '/'
        end
    end
    halt 401
end
# End of login routes

