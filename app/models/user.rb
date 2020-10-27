class User < ApplicationRecord
	attr_accessor :blocked
	has_secure_password
	has_many :restaurants
	has_many :orders
	validates :username, :lastname, :firstname, :user_type, :presence => true
end
