class CreateMessages < ActiveRecord::Migration[5.0]
  def up
    create_table :messages do |t|
      t.references :chatroom, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.text :content

      t.timestamps
    end
  end

  def down
  	drop_table :messages
  end
end
