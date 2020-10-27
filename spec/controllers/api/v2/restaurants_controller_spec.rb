require 'rails_helper'

RSpec.describe Api::V2::RestaurantsController do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe "CREATE" do
    before(:all) do
      @user = create(:user)
    end

    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        post :create
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get status 400 due to name is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
        }
        post :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("name is missing")
        expect(response.status).to eq(400)
      end 
      
      it "get status 400 due to description is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :name => "name",
        }
        post :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("description is missing")
        expect(response.status).to eq(400)
      end

      it "get status 400 due to user is not owner" do
        @user1 = create(:user , :user_type => 1)
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :name => "name",
            :description => "desc",
            :user_id => @user1.id 
        }
        post :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Not owner user")
        expect(response.status).to eq(400)
      end

      it "create a restaurant successfully" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = {
            :name => "name",
            :description => "desc",
            :user_id => @user.id 
        }
        post :create, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("Successful")
        expect(response.status).to eq(200)
      end

    end
  end

  describe "INDEX" do
    before(:all) do
      @restaurant = create(:restaurant)
    end

    context " Unauthorized" do
      it "get status 401 due to unauthorized" do
        get :index
        expect(response.status).to eq(401)
      end
    end 

    context "authorized" do
      it "get status 400 due to user_id is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = { }
        get :index, params: params
        message = JSON.parse(response.body)['message']
        expect(message).to eq("user_id is missing")
        expect(response.status).to eq(400)
      end 
      
      it "get status 400 due to user_id is missing" do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        params = { 
          :user_id => @restaurant.user.id
        }
        get :index, params: params
        json = JSON.parse(response.body)
        expect(response.body).to eq([@restaurant].to_json)
        expect(response.status).to eq(200)
      end
    end
  end
end