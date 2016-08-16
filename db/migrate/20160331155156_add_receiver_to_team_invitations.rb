class AddReceiverToTeamInvitations < ActiveRecord::Migration[5.0]
  def change
  	add_reference :team_invitations, :receiver, index: true
  end
end
