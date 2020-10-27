class CreateOrderMeals < ActiveRecord::Migration[6.0]
  def change
    create_table :order_meals do |t|
      #t.integer :meal_id
      t.integer :amount
      t.belongs_to :order
      t.belongs_to :meal
      t.timestamps
    end
  end
end
