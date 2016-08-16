class CreateSprints < ActiveRecord::Migration[5.0]
  def up
    create_table :sprints do |t|
      t.belongs_to :release, index: true
  		t.belongs_to :project, index: true
      t.string :name
      t.integer :status, default: 0
      t.integer :committed_effort
      t.integer :done_effort
    	t.datetime :start_date
      t.datetime :release_date

      t.timestamps
    end
  end

  def down
  	drop_table :sprints
  end
end
