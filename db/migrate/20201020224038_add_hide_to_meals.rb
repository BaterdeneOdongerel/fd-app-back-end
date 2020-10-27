class AddHideToMeals < ActiveRecord::Migration[6.0]
  def change
    add_column :meals, :hide, :integer, default: 0
  end
end
