class CreateTheme < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
    	t.string :name
      t.string :description
      t.string :status
      
  		t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
