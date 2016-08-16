class CreateRelease < ActiveRecord::Migration[5.0]
  def up
    create_table :releases do |t|
    	t.string :name
      t.string :description
      t.integer :status, default: 0
      
  		t.belongs_to :project, index: true

      t.timestamps
    end
  end

  def down
  	drop_table :releases
  end
end
