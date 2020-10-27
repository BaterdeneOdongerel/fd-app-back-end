require 'rails_helper'

RSpec.describe Api::V2::BlockusersController do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "CREATE_OR_UPDATE" do
  	before(:all) do
      @restaurant = create(:restaurant)
      @user = create(:user, :user_type => 1)
    end

    context " Unauthorized" do
  	  it "get status 401 due to unauthorized" do
        get :create_or_update
        expect(response.status).to eq(401)
      end
  	end 

    context "authorized" do
      it "get status 400 due to missing params" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :user_id => @user.id,
        }
        get :create_or_update, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("missing params")
        expect(response.status).to eq(400)
      end 
      
      it "block user by creating a block" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)

        params = {
            :user_id => @user.id,
            :restaurant_id => @restaurant.id,
            :blocked => true
        }
        get :create_or_update, params: params
        @blocked = BlockedUser.where({ :user_id => @user.id, :restaurant_id => @restaurant.id })
        expect(response.body).to eq(@blocked.last.to_json)
        expect(response.status).to eq(200)
      end

      it "block user by update a block" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        @blocked = create(:blocked_user, :user_id => @user.id, :restaurant_id => @restaurant.id, :blocked => true)
        params = {
            :user_id => @user.id,
            :restaurant_id => @restaurant.id,
            :blocked => false
        }
        get :create_or_update, params: params
        @blocked = BlockedUser.where({ :user_id => @user.id, :restaurant_id => @restaurant.id, :blocked => false })
        expect(response.status).to eq(200)
      end
  	end
  end

  describe "FETCH_USERS_BY_RESTAURANT" do
    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        get :fetch_users_by_restaurant
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get users of restaurant not block" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :restaurant_id => 1,
        }
        get :fetch_users_by_restaurant, params: params
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
        expect(response.status).to eq(200)
      end 
    end
  end
end