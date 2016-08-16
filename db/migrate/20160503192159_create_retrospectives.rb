class CreateRetrospectives < ActiveRecord::Migration[5.0]
  def up
    create_table :retrospectives do |t|
    	t.string :name
      t.string :description_good
      t.string :description_bad
      t.string :description_future
      
  		t.belongs_to :sprint, index: true
  		t.belongs_to :project, index: true

      t.timestamps
    end
  end

  def down
  	drop_table :retrospectives
  end
end
