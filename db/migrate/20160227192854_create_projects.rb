class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.belongs_to :team, index: true
      
      t.string :name
      t.string :description

      t.string :image_id
      t.string :image_filename
      t.integer :image_size
      t.string :image_content_type

      t.integer :def_sprint_dur
      t.boolean :def_proj_tips

      t.integer :total_file_limit_size
      t.boolean :active

      t.integer  :committed_work, default: 0, null: false

      t.timestamps
    end
  end
end
