class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :status
      t.belongs_to :user
      t.belongs_to :restaurant
      t.float :total
      t.text :comment_by_user
      t.timestamps
    end
  end
end
