class Api::V2::RestaurantsController < ApplicationController
	before_action :authorized
	def create
		unless is_valid(params)[:valid]
			render status: 400, json: is_valid(params)
			return
		end	
		res = Restaurant.new(
			:name => params[:name],
			:description => params[:description],
			:user_id => params[:user_id],
			:hide => 0
			)
		if res.user.user_type == 1
			render status: 400, json: {:message => "Not owner user"}
			return 
		end	
		if res.save!
		  render json: {:valid => true, :message => "Successful"}
		else
          render status: 400
		end	
	end

	def index
		if params[:user_id].present?
			count = params[:count].present? ? params[:count] : 0
			per_page = params[:per_page].present? ? params[:per_page] : 16
			
			@restaurants = Restaurant.where({user_id: params[:user_id]}).where.not(:hide => 1).order(id: :desc).limit(per_page).offset(count)
			render json: @restaurants
		else
			render status: 400, json: {message: "user_id is missing"}
		end
	end	
	
	def fetch_single_restaurant
		if params[:user_id].present? && params[:restaurant_id].present?
			@restaurant = Restaurant.where({ 
				:user_id => params[:user_id], 
				:id => params[:restaurant_id]
			})
			if @restaurant != nil
				render status: 200, json: @restaurant.last
			else
				render status: 400
			end	
		else
			render status: 400
		end 
	end	
	
	def update
		r = is_valid_update params
		unless r[:valid]
			render status: 400, json: r
			return 
		end
		@restaurant = Restaurant.find_by_id(params[:id])
		if (@restaurant != nil) 
			@restaurant = update_restaurant(@restaurant, params)
			if @restaurant.save!
				render json: @restaurant
			else
				render status: 400
			end	
		else
			render status: 400, json: { message: "cannot find the restaurant"}
		end	
	end		
	
	def delete_restaurant
		if params.has_key?(:restaurant_id)
			@restaurant = Restaurant.find_by_id(params[:restaurant_id])
			if @restaurant
				@restaurant.hide = 1
				@restaurant.save!
				render status: 200, json: []
			else
				render status: 400
			end	
		else
			render status: 400 
		end	
	end	
	
	def update_restaurant res, param 
		if param.has_key?(:name)
			res.name = param[:name] 
		end
		if param.has_key?(:description)
			res.description = param[:description] 
		end	
		res	
	end	
	
	def is_valid param
		unless param[:name].present?
			return { :valid => false, :message => "name is missing"}
		end
		
		unless param[:description].present?
			return { :valid => false, :message => "description is missing"}
		end

		unless param[:user_id].present?
			return { :valid => false, :message => "owner is missing"}
		end

		return { :valid => true, :message => "valid"}
	end	
	
	def is_valid_update param
		unless param[:name].present?
			return { :valid => false, :message => "name is missing"}
		end
		
		unless param[:description].present?
			return { :valid => false, :message => "description is missing"}
		end
		unless param[:id].present?
			return { :valid => false, :message => "id is missing"}
		end	
		return { :valid => true, :message => "valid"}
	end	
end
