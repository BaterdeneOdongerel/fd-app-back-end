class Meal < ApplicationRecord
	belongs_to :restaurant
	validates :name, :description, :price, :restaurant, :hide, :presence => true  
end
