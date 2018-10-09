module ProjectDetails
    def update_project_details
        id = params[:id]
        title = params[:id]
        description = params[:description]
        start_date = params[:start_date]
        end_date = params[:end_date]
        goal = params[:goal]
        status = params[:status]

        $db.exec(
            "UPDATE projects 
            SET title='#{title}', description='#{description}',
                goal='#{goal}', status='#{status}'
            WHERE id = '#{id}';"
        )
    end
end