module Utils
    # Converts empty string hash values to NULL
    # to prevent storing empty strings in db when there is no user input
    # Surrounds the strings with inverted commas if they are not empty
    def process_input(hash)
        hash.each do |key, value|
            if hash[key] == ''
                hash[key] = 'NULL'
            else
                hash[key] = "'#{hash[key]}'"
            end
        end
    end

    # Checks if user is authenticated.
    # Sends HTTP 401 Not Authorized if not authenticated.
    # Call this method in routes that require the user to be authenticated.
    def require_authenticated
        if !session[:email]
            halt 401
        end
    end

    def require_admin_authenticated
        if !session[:email] && session[:isadmin] != 't'
            halt 401
        end
    end
end
