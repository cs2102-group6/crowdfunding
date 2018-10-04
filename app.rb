require 'sinatra'
require 'pg'

dbconfig = {
    dbname: 'crowdfunding',
    host: 'localhost',
    port: '5432',
    user: 'postgres',
    password: 'password'
}
db = PG::Connection.open(dbconfig)

get '/' do
    erb :index
end

post '/login' do
      
end

post '/register' do
    # The params hash contains information in the post request
    # params[:key] is the value where <input name="key"> in the view
    email = params[:email]
    password = params[:password]
    first_name = params[:first_name]
    last_name = params[:last_name]
    res = db.exec(
        "INSERT INTO users
        (email, password, first_name, last_name, is_admin)
        VALUES ('#{email}', '#{password}', '#{first_name}', '#{last_name}', false);"
    )
    redirect '/'
end
