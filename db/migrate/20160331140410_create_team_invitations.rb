class CreateTeamInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :team_invitations do |t|
    	t.boolean :is_active

    	t.timestamps
    end
  end
end
