class CreateSprintBacklogs < ActiveRecord::Migration[5.0]
  def up
    create_table :sprint_backlogs do |t|
  		t.belongs_to :sprint, index: true

      t.timestamps
    end
  end

  def down
  	drop_table :sprint_backlogs
  end
end
