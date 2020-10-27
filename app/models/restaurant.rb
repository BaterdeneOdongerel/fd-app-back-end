class Restaurant < ApplicationRecord
	belongs_to :user
	has_many :meals
	has_many :orders
	has_many :blocked_users
    has_many :users, through: :blocked_users
	validates :name, :description, :user, :hide, :presence => true
end
