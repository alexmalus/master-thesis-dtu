class AddInvitedInTeamIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :invited_on_team_id, :integer
  end
end
