class OrderHistory < ApplicationRecord
	belongs_to :order
	#attr_accessor :order_id, :flow_id, :created_at, :updated_at
end
