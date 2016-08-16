class AddSenderToTeamInvitations < ActiveRecord::Migration[5.0]
  def change
  	add_reference :team_invitations, :sender, index: true
  end
end
