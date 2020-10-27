class Api::V2::MealsController < ApplicationController
	before_action :authorized
	def create
		r = is_valid params
		unless r[:valid]
			render status: 400, json: r
			return
		end	
		meal = Meal.new(
			:restaurant_id => params[:restaurant_id],
			:name => params[:name],
			:description => params[:description],
			:price => params[:price]
			)
		if meal.save!
		  render status: 200, json: {message: "successful"}
		else
          render status: 400
		end	
	end

	def index
		if params[:restaurant_id].present? && params[:user_id].present?
			restaurant = Restaurant.find_by_id(params[:restaurant_id])
			meal = Meal.where({ :restaurant_id => params[:restaurant_id]}).where.not(:hide => 1)
			if (restaurant && restaurant.user_id.to_s == params[:user_id].to_s)	
				render json: meal
			else
				render status: 400, json: {message: "user id doesn't match with owner id"}
			end	
		else
		 	render status: 400, json: {message: "invalid params"}
		end	
	end	
	
	def fetch_single_meal
		if params[:restaurant_id].present? && params[:meal_id].present?
			meal = Meal.where({ :restaurant_id => params[:restaurant_id] , :id => params[:meal_id]})
			if meal	&& meal.count > 0
				render json: meal.last
			else
				render status: 400, json: { message: "meal id or restaurant id is wrong"}
			end	
		else
		 	render status: 400, json: { message: "invalid params"}
		end	
	end	
	
	def update
		r = is_valid_update params
		unless r[:valid]
			render status: 400, json: r
			return
		end	
		meal = Meal.find_by_id(params[:id])
		if (meal != nil) 
			meal = update_meal_with_attributes(meal, params)
			meal.save!
			render json: meal
		else
			render status: 400, json: {message: "no meal found"}
		end	
	end		

	def delete_meal 
		if (params[:user_id].present? && params[:meal_id].present?)
			meal = Meal.find_by_id(params[:meal_id])
			if meal && meal.restaurant.user_id == params[:user_id]
				meal.hide = 1
				meal.save!
				render json: {message: "success"}
			else
				render status: 400, json: {message: "Invalid params"}
			end	
		else
			render status: 400, json: {message: "Invalid params"}
		end
	end	
	
	def update_meal_with_attributes res, param 
		if (param[:name])
			res.name = param[:name] 
		end
		if (param[:description])
			res.description = param[:description] 
		end	
		if (param[:restaurant_id])
			res.restaurant_id = param[:restaurant_id] 
		end
		if (param[:price])
			res.price = param[:price] 
		end
		res	
	end		

	def is_valid param
		unless param[:restaurant_id].present?
			return { :valid => false, :message => "Restaurant Id is missing"}
		end
		unless param[:name].present?
			return { :valid => false, :message => "name is missing"}
		end
		unless param[:description].present?
			return { :valid => false, :message => "description is missing"}
		end

		unless param[:price].present?
			return { :valid => false, :message => "price is missing"}
		end	
		return { :valid => true, :message => "valid"}
	end	

	def is_valid_update param
		unless param[:id].present?
			return { :valid => false, :message => "Id is missing"}
		end
		unless param[:name].present?
			return { :valid => false, :message => "name is missing"}
		end
		unless param[:description].present?
			return { :valid => false, :message => "description is missing"}
		end

		unless param[:price].present?
			return { :valid => false, :message => "price is missing"}
		end	
		return { :valid => true, :message => "valid"}
	end	
end
