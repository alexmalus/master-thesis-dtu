class CreateDocuments < ActiveRecord::Migration[5.0]
  def up
    create_table :documents do |t|
    	t.belongs_to :project
    	t.belongs_to :sprint
    	t.belongs_to :release
    	t.belongs_to :user_story
    	
    	t.string :file_id, null: false
      t.string :file_filename, null: false
      t.string :file_size, null: false
      t.string :file_content_type, null: false

      t.timestamps
    end
  end

  def down
    drop_table :documents
  end
end