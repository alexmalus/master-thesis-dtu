class CreateUserFeedback < ActiveRecord::Migration[5.0]
  def change
    create_table :user_feedbacks do |t|
    	t.string :name
      t.string :contact_info
      t.string :description

      t.timestamps
    end
  end
end
