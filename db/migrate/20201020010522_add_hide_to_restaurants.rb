class AddHideToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :hide, :integer
  end
end
