class CreateProductBacklogs < ActiveRecord::Migration[5.0]
  def change
    create_table :product_backlogs do |t|
      t.string :category
  		t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
