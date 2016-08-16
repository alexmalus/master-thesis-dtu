class CreateSprintDoneWork < ActiveRecord::Migration[5.0]
  def change
    create_table :sprint_done_works do |t|
    	t.belongs_to :sprint
    	t.integer :project_id
    	t.integer :committed_work

    	t.timestamps
    end
  end
end
