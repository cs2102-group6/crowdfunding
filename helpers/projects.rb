module Projects
    def create_project
            id=params[:id]
            title=params[:title]
            description=params[:description]
            start_date=params[:start_date]
            end_date=params[:end_date]
            goal=params[:goal]
            creator_email=session[:email]
            status=params[:status]
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
        # id = params[:id]
        # title = params[:title]
        # description = params[:description]
        # start_date = params[:start_date]
        # end_date = params[:end_date]
        # goal = params[:goal]
        # status = params[:status]

        # $db.exec(
        #     "UPDATE projects 
        #     SET title='#{title}', description='#{description}',
        #         goal='#{goal}', status='#{status}'
        #     WHERE id = '#{id}';"
        # )
        $db.exec(
            "UPDATE projects SET 
            title='#{params[:title]}',
            description='#{params[:description]}',
            start_date='#{params[:start_date]}',
            end_date='#{params[:end_date]}',
            goal='#{params[:goal]}',
            status='#{params[:status]}'
            WHERE id='#{params[:id]}';"
        ) 
    end
    
end

