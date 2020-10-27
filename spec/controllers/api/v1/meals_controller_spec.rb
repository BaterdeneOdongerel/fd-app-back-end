require 'rails_helper'

RSpec.describe Api::V1::MealsController do
  before(:all) do
    @meal = create(:meal)
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end


  describe "GET " do
  	context " Unauthorized" do
  	  it "get status 401 due to unauthorized" do
    	get :index
     	expect(response.status).to eq(401)
      end
  	end 

    context "authorized" do
  	  it "fetch available meals by a restaurant" do
  	  	id = @meal.restaurant.id
  	  	allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        get :index, params: {:restaurant_id => id, :params => {:restaurant_id => id}}
        expect(response.body).to eq([@meal].to_json)
      end

      it "get status 400 due to missing an expected param" do
      	allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
    	get :index
     	expect(response.status).to eq(400)
      end
  	end
  end
end