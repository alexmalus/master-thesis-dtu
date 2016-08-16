class AddOwnerToTeams < ActiveRecord::Migration[5.0]
  def change
  	add_reference :teams, :owner, index: true
  end
end
