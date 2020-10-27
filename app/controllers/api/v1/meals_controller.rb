class Api::V1::MealsController < ApplicationController
	before_action :authorized
	def index
		if params[:restaurant_id].present?
			meal = Meal.where({ :restaurant_id => params[:restaurant_id]}).where.not(:hide => 1)
			render json: meal
		else
		 	render status: 400, json: { message: "restaurant_id is missing"}
		end	
	end	
end
