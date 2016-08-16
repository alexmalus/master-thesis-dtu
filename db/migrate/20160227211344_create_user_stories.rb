class CreateUserStories < ActiveRecord::Migration[5.0]
  def up
    create_table :user_stories do |t|
      t.string :name
      t.string :description
      t.string :acceptance_condition
      t.integer :priority
      t.integer :effort
      t.integer :status, default: 0
      t.boolean :is_task, default: false
      t.datetime :finished_date

      t.belongs_to :product_backlog, index: true
      t.belongs_to :sprint_backlog, index: true
      t.belongs_to :epic, index: true
  		t.belongs_to :theme, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end

  def down
    drop_table :user_stories
  end
end
