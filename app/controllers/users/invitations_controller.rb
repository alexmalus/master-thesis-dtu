class Users::InvitationsController < Devise::InvitationsController
  def update
    # if this
    #   redirect_to root_path
    # else
      super
      # assign user to the inviters team
      if resource.invited_on_team_id
        team = Team.where("id = ?", resource.invited_on_team_id).first
        resource.add_role :member, User
        resource.add_role :member, team
        resource.teams << team

        team.projects.each do |project|
          resource.add_role :member, project
        end
      end
    # end
      # current_user.teams << @team
    # end
  end

end