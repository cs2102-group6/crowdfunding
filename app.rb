require 'sinatra'
require 'pg'

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

before do
    process_input(params)
end

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
    create_user
    redirect '/'
end

post '/login' do
    res = find_user
    if res.values.length != 0 # User exists
        session[:authenticated] = true
        redirect '/'
    end
    halt 401
end
# End of login routes

