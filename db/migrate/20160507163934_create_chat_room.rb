class CreateChatRoom < ActiveRecord::Migration[5.0]
  def up
    create_table :chatrooms do |t|
      t.references :team, index: true, foreign_key: true

      t.string :title

      t.timestamps
    end
  end

  def down
  	drop_table :chatrooms
  end
end
