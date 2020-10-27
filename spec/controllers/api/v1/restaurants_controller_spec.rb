require 'rails_helper'

RSpec.describe Api::V1::RestaurantsController do
  
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "INDEX" do
  	before(:all) do
      @restaurant = create(:restaurant)
      @user = create(:user, :user_type => 1)
    end

    context " Unauthorized" do
  	  it "get status 401 due to unauthorized" do
        get :index
        expect(response.status).to eq(401)
      end
  	end 

    context "authorized" do
      it "get empty [] due to blocked user" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        @blocked = create(:blocked_user, :user_id => @user.id, :restaurant_id => @restaurant.id, :blocked => true)
        params = {
            :user_id => @user.id,
        }
        get :index, params: params
        expect(response.body).to eq("[]")
      end 
      

      it "get Restaurants order successfully" do
        @r = Restaurant.all.where.not(:hide => 1).order(id: :desc)
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :user_id => @user.id,
        }
        get :index, params: params
        expect(response.body).to eq(@r.to_json)
      end
  	end
  end

  describe "FETCH_SINGLE_RESTAURANT" do
    before(:all) do
      @restaurant = create(:restaurant)
      @user = create(:user, :user_type => 1)
    end

    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        get :fetch_single_restaurant
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get empty [] due to blocked user" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        @blocked = create(:blocked_user, :user_id => @user.id, :restaurant_id => @restaurant.id, :blocked => true)
        params = {
            :user_id => @user.id,
            :restaurant_id => @restaurant.id
        }
        get :fetch_single_restaurant, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("invalid params")
      end 
      
      it "get one restaurant successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :user_id => @user.id,
            :restaurant_id => @restaurant.id
        }
        get :fetch_single_restaurant, params: params
        expect(response.body).to eq(@restaurant.to_json)
      end
    end
  end
end

