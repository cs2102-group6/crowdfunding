module Users
    def create_user
        # The params hash contains information in the post request
        # params[:key] is the value where <input name="key"> in the view
        email = params[:email]
        password = params[:password]
        first_name = params[:first_name]
        last_name = params[:last_name]
        $db.exec(
            "INSERT INTO users
             (email, password, first_name, last_name, is_admin)
             VALUES (#{email}, #{password}, #{first_name}, #{last_name}, false);"
        )
    end

    def find_user
        $db.exec(
            "SELECT * FROM users
           WHERE email=#{params[:email]}"
        )
    end

    def delete_user
        $db.exec(
            "DELETE FROM users
            WHERE email=#{params[:email]}"
        ) 
    end
end

