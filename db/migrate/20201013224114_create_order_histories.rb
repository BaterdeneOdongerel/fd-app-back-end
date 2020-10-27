class CreateOrderHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :order_histories do |t|
      #t.integer :order_id
      t.belongs_to :order
      t.integer :order_status
      t.timestamps
    end
  end
end
