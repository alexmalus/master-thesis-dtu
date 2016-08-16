class AddTeamToTeamInvitations < ActiveRecord::Migration[5.0]
  def change
  	add_reference :team_invitations, :team, index: true, foreign_key: true
  end
end
