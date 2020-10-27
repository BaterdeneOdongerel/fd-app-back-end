class CreateBlockedUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :blocked_users do |t|
      t.belongs_to :user
      t.belongs_to :restaurant
      #t.integer :user_id
      #t.integer :restaurant_id
      t.boolean :blocked
      t.timestamps
    end
  end
end
