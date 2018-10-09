module Admins
    def create_admin
        # The params hash contains information in the post request
        # params[:key] is the value where <input name="key"> in the view
        email = params[:email]
        password = params[:password]
        first_name = params[:first_name]
        last_name = params[:last_name]
        is_admin = true
      
        $db.exec(
            "INSERT INTO users
             (email, password, first_name, last_name, is_admin)
             VALUES (#{email}, #{password}, #{first_name}, #{last_name}, #{is_admin});"
        )
    end
end