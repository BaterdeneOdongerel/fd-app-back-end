class Api::V2::OrdersController < ApplicationController
	before_action :authorized
	def show_owner_order
		if (params[:user_id].present?)
			count = params[:count].present? ? params[:count] : 0
			per_page = params[:per_page].present? ? params[:per_page] : 10
			
			orders = Order.joins(:restaurant).where("restaurants.user_id = ?", params[:user_id]).order(id: :desc).limit(per_page).offset(count)
			render json: orders.to_json( :include => { :order_histories => {}, :user => {},:restaurant => {}, :order_meals => { :include => :meal} })
		else
			render status: 400, json: {message: "user_id is missing"}
		end	
	end	

    # 1 placed
    # 2 canceled
    # 3 Processing
    # 4 In Route
    # 5 Delivered
    # 6 Recieved 
	
	def update_order 
		unless params[:id].present? && params[:next_status].present? && params[:user_id].present? 
			render status: 400, json: { message: "Missing params"}
			return 
		end	
		id = params[:id]
		next_status = params[:next_status]
		user_id = params[:user_id]
		order = Order.find_by_id(id)
		if order
			if (user_id.to_s == order.restaurant.user.id.to_s)
            	render update_by_owner(order, next_status)
            else
            	render status: 400, json: {message: "Owner id doesn't match with user id", valid: false}
            end	
		else
			render status: 400, json: {message: "wrong input", valid: false}
		end	
	end	
	
	def update_by_owner order, next_status
		if ( (order.status == 1 && next_status.to_s == "3") || ( order.status == 3 && next_status.to_s == "4") || ( order.status == 4 && next_status.to_s == "5") )
			order.status = next_status
			order.save!
			order_history = OrderHistory.new( :order_id => order.id, :order_status => next_status)
			order_history.save!
			{status: 200, json: {message: "Successful", valid: true}}
		else
			{status: 400, json: {message: "status change is not allowed", valid: false}}
		end	
	end
end
