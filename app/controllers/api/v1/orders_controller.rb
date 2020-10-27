class Api::V1::OrdersController < ApplicationController
	before_action :authorized
	def create
		valid = is_valid_param params
		if (valid[:valid] == false)
			render status: 400, json: valid
			return 
		end	
		total_price = 0.0
		count = 0
		params[:meals].each do |current_meal|
			meal = Meal.find_by_id(current_meal[:id])
			if meal && current_meal[:amount].present? && current_meal[:amount].to_i > 0 
				total_price = total_price + meal.price * (current_meal[:amount].to_i)
				count = count + current_meal[:amount].to_i
				order_meal = OrderMeal.new(
					:meal_id => current_meal[:id],
					:amount => current_meal[:amount]
				)
			end	
		end	

		order = Order.new(
			:status => 1,
			:user_id => params[:user_id],
			:restaurant_id => params[:restaurant_id],
			:comment_by_user => params[:comment],
			:total => total_price
			)

		if count > 0 && order.save!
		  create_meal_order params[:meals], order.id
		  create_histoty order.id
		  render status: 200
		else
          render status: 400
		end
	end
	
	def show_user_order
		if (params[:user_id].present?)
			count = params[:count].present? ? params[:count] : 0
			per_page = params[:per_page].present? ? params[:per_page] : 10
			orders = Order.where({user: params[:user_id]}).order(id: :desc).limit(per_page).offset(count)
			render json: orders.to_json( :include => { :order_histories => {}, :user => {},:restaurant => {}, :order_meals => { :include => :meal} })
		else
			render json: [] 
		end	
	end	
	
	def create_meal_order meals, order_id
		meals.each do |current_meal|
			order_meal = OrderMeal.new( :order_id => order_id, :meal_id => current_meal[:id], :amount => current_meal[:amount])
			order_meal.save!
		end	
	end	

	def create_histoty order_id
		order_history = OrderHistory.new( :order_id => order_id, :order_status => 1)
		order_history.save!
	end	

    # 1 placed
    # 2 canceled
    # 3 Processing
    # 4 In Route
    # 5 Delivered
    # 6 Recieved 
	
	def update_order 
		id = params[:id]
		next_status = params[:next_status]
		user_id = params[:user_id]
		order = Order.find_by_id(id)
		if order
			if (user_id && user_id.to_s == order.user_id.to_s)
            	render update_by_regular_user(order, next_status)
            else
            	render status: 400, json: {message: "user id is wrong", valid: false}
            end	
		else
			render status: 400, json: {message: "wrong input", valid: false}
		end	
	end	

	def update_by_regular_user order, next_status
		if ( (order.status == 1 && next_status.to_s == "2") || ( order.status == 5 && next_status.to_s == "6") )
			order.status = next_status
			order.save!
			order_history = OrderHistory.new( :order_id => order.id, :order_status => next_status)
			order_history.save!
			{status: 200, json: {message: "Successful", valid: true}}
		else
			{status: 400, json: {message: "status change is not allowed", valid: false}}
		end	
	end

	def is_valid_param param
		unless param[:meals].present?
			return {:valid => false, :message => "Meals' id missing"}
		end
		unless param[:user_id].present?
			return {:valid => false, :message => "User id missing"}
		end
		unless param[:restaurant_id].present?
			return {:valid => false, :message => "Restaurant id missing"}
		end
		return {:valid => true, :message => "Successful"}
	end	
end
