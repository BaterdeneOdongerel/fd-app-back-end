class BlockedUser < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant
	validates :user, :restaurant, :presence => true  
end
