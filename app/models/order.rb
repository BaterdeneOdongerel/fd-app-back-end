class Order < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant
	has_many :order_meals
	has_many :order_histories
	has_many :meals , through: :order_meals
	validates :user, :restaurant, :presence => true  
end
