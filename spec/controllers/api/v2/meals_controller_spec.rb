require 'rails_helper'

RSpec.describe Api::V2::MealsController do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "CREATE" do
  	before(:all) do
      @restaurant = create(:restaurant)
    end

    context " Unauthorized" do
  	  it "get status 401 due to unauthorized" do
        get :create
        expect(response.status).to eq(401)
      end
  	end 

    context "authorized" do
      it "get status 400 due to Restaurant Id is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :name => "meal1",
            :description => "description1",
            :price => 15.6
        }
        get :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Restaurant Id is missing")
        expect(response.status).to eq(400)
      end 
      
      it "get status 400 due to name is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :restaurant_id => @restaurant.id,
            :description => "description1",
            :price => 15.6
        }
        get :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("name is missing")
        expect(response.status).to eq(400)
      end

      it "create a meal successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :restaurant_id => @restaurant.id,
            :name => "meal name",
            :description => "description1",
            :price => 15.6
        }
        get :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("successful")
        expect(response.status).to eq(200)
      end
  	end
  end

  describe "INDEX" do
    before(:all) do
      @meal = create(:meal)
    end

    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        get :index
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get status 400 due to invalid params" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :restaurant_id => @meal.id
        }
        get :index, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("invalid params")
        expect(response.status).to eq(400)
      end 
      
      it "get status 400 due to user id doesn't match with owner id" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :restaurant_id => @meal.restaurant.id,
          :user_id => -1
        }
        get :index, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("user id doesn't match with owner id")
        expect(response.status).to eq(400)
      end

      it "get meals successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :restaurant_id => @meal.restaurant.id,
          :user_id => @meal.restaurant.user.id
        }
        get :index, params: params
        expect(response.body).to eq([@meal].to_json)
        expect(response.status).to eq(200)
      end
    end
  end

  describe "FETCH_SINGLE_MEAL" do
    before(:all) do
      @meal = create(:meal)
    end

    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        get :fetch_single_meal
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get status 400 due to meal id or restaurant id is wrong" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :restaurant_id => @meal.restaurant.id,
          :meal_id => -1
        }
        get :fetch_single_meal, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("meal id or restaurant id is wrong")
        expect(response.status).to eq(400)
      end 
      
      it "get status 400 due to invalid params" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :restaurant_id => @meal.restaurant.id,
        }
        get :fetch_single_meal, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("invalid params")
        expect(response.status).to eq(400)
      end

      it "get a meal successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :restaurant_id => @meal.restaurant.id,
          :meal_id => @meal.id
        }
        get :fetch_single_meal, params: params
        expect(response.body).to eq(@meal.to_json)
        expect(response.status).to eq(200)
      end
    end
  end

  describe "UPDATE" do
    before(:all) do
      @meal = create(:meal)
    end

    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        post :update
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get status 400 due to Id is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
        }
        post :update, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Id is missing")
        expect(response.status).to eq(400)
      end 
      
      it "get status 400 due to name is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :id => @meal.id,
        }
        post :update, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("name is missing")
        expect(response.status).to eq(400)
      end

      it "get status 400 due to no meal found" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :id => -1,
          :name => "new name",
          :description => "new desc",
          :price => 100
        }
        post :update, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("no meal found")
        expect(response.status).to eq(400)
      end

      it "update successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
          :id => @meal.id,
          :name => "new name",
          :description => "new desc",
          :price => 100
        }
        post :update, params: params
        expect(response.status).to eq(200)
      end
    end
  end

end