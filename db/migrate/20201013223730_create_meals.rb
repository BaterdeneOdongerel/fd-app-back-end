class CreateMeals < ActiveRecord::Migration[6.0]
  def change
    create_table :meals do |t|
      t.string :name
      t.text :description
      t.float :price
	  t.belongs_to :restaurant
      t.timestamps
    end
  end
end
