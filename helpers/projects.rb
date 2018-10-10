require 'pry'

module Projects
    def create_project
            title=params[:title]
            description=params[:description]
            start_date=params[:start_date]
            end_date=params[:end_date]
            goal=params[:goal]
            creator_email=session[:email]
            status=params[:status]

            # binding.pry

        $db.exec(
            "INSERT INTO projects (title, description, start_date, end_date, goal, creator_email, status)
             VALUES ('#{title}', '#{description}', '#{start_date}', '#{end_date}', #{goal}, '#{creator_email}', '#{status}');"
        )
    end

    def delete_project(id)
        id=id
        binding.pry
        $db.exec(
            "DELETE FROM projects
            WHERE id=#{id}"
        ) 
    end

    def update_project(id)
        # title=params[:title]
        # description=params[:description]
        # start_date=params[:start_date]
        # end_date=params[:end_date]
        # goal=params[:goal]
        # status=params[:status]
        # id=id

        # binding.pry
        $db.exec(
            "UPDATE projects SET 
            title='#{params[:title]}',
            description='#{params[:description]}',
            start_date='#{params[:start_date]}',
            end_date='#{params[:end_date]}',
            goal=#{params[:goal]},
            status='#{params[:status]}'
            WHERE id=#{id}"
        ) 
    end
    
end

