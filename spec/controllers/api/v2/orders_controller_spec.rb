require 'rails_helper'

RSpec.describe Api::V2::OrdersController do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
  describe "UPDATE_ORDER" do
    
    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
      post :update_order
      expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      before(:all) do
        @user1 = create(:user, :user_type => 1)
        @meal = create(:meal)
        @order = create(:order, :user_id => @user1.id , :restaurant_id => @meal.restaurant.id)
        @order_meal = create(:order_meal, :order_id => @order.id, :meal_id => @meal.id)
      end

      it "get status 400 due to Missing params " do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => @user1.id,
        }
        post :update_order, params: params
        expect(response.status).to eq(400)
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Missing params")
      end 

      it "get status 400 due to Owner id doesn't match with user id" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => -1,
          :id => @order.id,
          :next_status => 2
        }
        post :update_order, params: params
        expect(response.status).to eq(400)
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Owner id doesn't match with user id")
      end  

      it "get status 400 due to wrong input" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => @user1.id,
          :id => -1,
          :next_status => 4
        }
        post :update_order, params: params
        expect(response.status).to eq(400)
        message = JSON.parse(response.body)['message']
        expect(message).to eq("wrong input")
      end 


       it "change status from 1 to 3 => PROCESSING status" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => @order.restaurant.user.id,
          :id => @order.id,
          :next_status => 5
        }
        post :update_order, params: params
        message = JSON.parse(response.body)['message']
        expect(response.status).to eq(400)
        expect(message).to eq("status change is not allowed")
      end 

      it "change status from 1 to 3 => PROCESSING status" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => @order.restaurant.user.id,
          :id => @order.id,
          :next_status => 3
        }
        post :update_order, params: params
        message = JSON.parse(response.body)['message']
        expect(response.status).to eq(200)
        expect(message).to eq("Successful")
      end 

      it "change status from 3 to 4 => IN ROUTE status" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => @order.restaurant.user.id,
          :id => @order.id,
          :next_status => 4
        }
        @order.status = 3
        @order.save!
        post :update_order, params: params
        message = JSON.parse(response.body)['message']
        expect(response.status).to eq(200)
        expect(message).to eq("Successful")
      end  

      it "change status from 4 to 5 => DELIVERED status" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :user_id => @order.restaurant.user.id,
          :id => @order.id,
          :next_status => 5
        }
        @order.status = 4
        @order.save!
        post :update_order, params: params
        expect(response.status).to eq(200)
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Successful")
      end 
    end  
  end  
end

