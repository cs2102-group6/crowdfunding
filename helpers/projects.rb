module Projects
    def create_project(email)
            id=params[:id]
            title=params[:title]
            description=params[:description]
            start_date=params[:start_date]
            end_date=params[:end_date]
            goal=params[:goal]
            creator_email=email
            # creator_email=params[:creator_email]
            status=params[:status]
            puts creator_email
        $db.exec(
            "INSERT INTO projects
             VALUES (#{id}, '#{title}', '#{description}', '#{start_date}', '#{end_date}', #{goal}, '#{creator_email}', '#{status}');"
        )
    end

    def delete_project
        $db.exec(
            "DELETE FROM projects
            WHERE id=#{params[:id]}"
        ) 
    end

    def update_project
        $db.exec(
            "UPDATE projects SET 
            title=#{params[:title]},
            description=#{params[:description]},
            start_date=#{params[:start_date]},
            end_date=#{params[:end_date]},
            goal=#{params[:goal]},
            status=#{params[:status]}
            WHERE id=#{params[:id]}"
        ) 
    end
    
end

