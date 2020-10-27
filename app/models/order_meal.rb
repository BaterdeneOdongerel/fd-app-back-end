class OrderMeal < ApplicationRecord
	belongs_to :meal
	belongs_to :order
	validates :meal, :order, :presence => true  
end
