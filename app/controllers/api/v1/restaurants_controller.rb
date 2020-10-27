class Api::V1::RestaurantsController < ApplicationController
	before_action :authorized
	def index
		if params[:user_id].present?
			count = params[:count].present? ? params[:count].to_i : 0
			per_page = params[:per_page].present? ? params[:per_page].to_i : 20

			blocked_users = BlockedUser.where({user_id: params[:user_id], blocked: true})
			@restaurants = Restaurant.all.where.not(:hide => 1).order(id: :desc)
			hash = Hash.new
			blocked_users.each do |buser| 
				hash[buser.restaurant_id] = true
			end
			res = @restaurants.select{ |r| !hash.has_key?(r.id) }.slice(count, per_page)

			render json: res
		else
			render json: []
		end
	end	
	
	def fetch_single_restaurant
		if params[:user_id].present? && params[:restaurant_id].present?
			@restaurant = Restaurant.where(:id => params[:restaurant_id])
			@blocked_users = BlockedUser.where( {
				:user_id => params[:user_id], 
				:id => params[:restaurant_id],
				:blocked => true
			})
			if @restaurant && (@blocked_users == nil || @blocked_users.count == 0)
				render status: 200, json: @restaurant.last
			else
				render status: 400, json: { message: "invalid params"}
			end	
		else
			render status: 400, json: { message: "invalid params"}
		end 
	end		
end
