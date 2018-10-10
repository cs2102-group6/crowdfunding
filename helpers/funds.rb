module Funds
    def create_funds
            amount= params[:amount]
            project_id= params[:project_Id]
            user_email= session[:email]
            
        $db.exec(
            "INSERT INTO funds
             VALUES (#{amount}, #{project_id},'#{user_email}');"
        )
    end
    
end

