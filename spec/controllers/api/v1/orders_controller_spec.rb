require 'rails_helper'

RSpec.describe Api::V1::OrdersController do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "CREATE" do
  	before(:all) do
      @user = create(:user, :user_type => 1)
      @meal1 = create(:meal)
      @meal2 = create(:meal, :name => "meal2")
    end

    context " Unauthorized" do
  	  it "get status 401 due to unauthorized" do
    	post :create
     	expect(response.status).to eq(401)
      end
  	end 
    context "authorized" do
  	  context "invalid params" do  	    
        it " meals is missing" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => @user.id,
            :restaurant_id => @meal1.restaurant.id
          }
          post :create, params: params
          message = JSON.parse(response.body)['message']
          expect(message).to eq("Meals' id missing")
          expect(response.status).to eq(400)
        end
        
        it " restaurant_id is missing" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :meals => [ {id: @meal1.id, amount: 2}],
            :user_id => @user.id
          }
          post :create, params: params
          message = JSON.parse(response.body)['message']
          expect(message).to eq("Restaurant id missing")
          expect(response.status).to eq(400)
        end

        it "total amount is 0" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :meals => [ {id: @meal1.id, amount: 0}],
            :user_id => @user.id,
            :restaurant_id => @meal1.restaurant.id
          }
          post :create, params: params
          expect(response.status).to eq(400)
        end  
      end

      it "order successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :meals => [ {id: @meal1.id, amount: 2}],
            :user_id => @user.id,
            :restaurant_id => @meal1.restaurant.id
        }
        post :create, params: params
        expect(response.status).to eq(200)
        order_meal = OrderMeal.where({ :meal_id => @meal1.id })
        expect(order_meal.first.meal).to eq(@meal1)
      end

  	end
  end


  describe "SHOW_USER_ORDER" do
    
    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
      post :show_user_order
      expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      describe "successfully requests" do
        it "get orders " do
          @user1 = create(:user, :user_type => 1)
          @order = create(:meal)
          @order_meal = create(:order, :user_id => @user1.id , :restaurant_id => @order.restaurant.id)

          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => @user1.id,
          }
          post :show_user_order, params: params
          expect(response.status).to eq(200)
        end 

        it "get empty [] due to wrong user id " do
          @user1 = create(:user, :user_type => 1)
          @order = create(:meal)
          @order_meal = create(:order, :user_id => @user1.id , :restaurant_id => @order.restaurant.id)

          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => -1,
          }
          post :show_user_order, params: params
          expect(response.status).to eq(200)
          expect(response.body).to eq("[]")
        end  
      end  
    end
  end  


  describe "UPDATE_ORDER" do
    
    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
      post :update_order
      expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      

      describe "update requests" do
        before(:all) do
          @user1 = create(:user, :user_type => 1)
          @meal = create(:meal)
          @order = create(:order, :user_id => @user1.id , :restaurant_id => @meal.restaurant.id)
          @order_meal = create(:order_meal, :order_id => @order.id, :meal_id => @meal.id)
        end
        it "order doesn't exist " do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => @user1.id,
            :id => -1,
            :next_status => 2
          }
          post :update_order, params: params
          expect(response.status).to eq(400)
          message = JSON.parse(response.body)['message']
          expect(message).to eq("wrong input")
        end 

        it "user id doesn't match with order's user id" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => -1,
            :id => @order.id,
            :next_status => 2
          }
          post :update_order, params: params
          expect(response.status).to eq(400)
          message = JSON.parse(response.body)['message']
          expect(message).to eq("user id is wrong")
        end  

        it "fails due to changing status that is not allowed by Regular user" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => @user1.id,
            :id => @order.id,
            :next_status => 4
          }
          post :update_order, params: params
          expect(response.status).to eq(400)
          message = JSON.parse(response.body)['message']
          expect(message).to eq("status change is not allowed")
        end 

        it "change status from 1 to 2 => CANCELED status" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => @user1.id,
            :id => @order.id,
            :next_status => 2
          }
          post :update_order, params: params
          expect(response.status).to eq(200)
          message = JSON.parse(response.body)['message']
          expect(message).to eq("Successful")
        end 
        it "change status from 5 to 6 => RECEIVED status" do
          allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
          params = {
            :user_id => @user1.id,
            :id => @order.id,
            :next_status => 6
          }
          @order.status = 5
          @order.save!
          post :update_order, params: params
          expect(response.status).to eq(200)
          message = JSON.parse(response.body)['message']
          expect(message).to eq("Successful")
        end   
      end  
    end
  end  
end

