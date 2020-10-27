require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
  describe "SIGNUP " do
	  it "get status 400 due to username missing" do
      params = {
        firstname: "fname",
        lastname: "lname",
        user_type: 1,
        password: "pass",
        confirm_password: "pass"
      }
    	post :signup, params: params
     	expect(response.status).to eq(400)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("username is missing")
    end

    it "get status 400 due to password doesn't match" do
      params = {
        username: "usertest1",
        firstname: "fname",
        lastname: "lname",
        user_type: 1,
        password: "pass2",
        confirm_password: "pass1"
      }
      post :signup, params: params
      expect(response.status).to eq(400)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("password doesn't match")
    end

    it "get status 400 due to user already exists" do
      @user = create(:user)
      params = {
        username: @user.username,
        firstname: "fname",
        lastname: "lname",
        user_type: 1,
        password: "pass1",
        confirm_password: "pass1"
      }
      post :signup, params: params
      expect(response.status).to eq(400)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("username already exists")
    end

    it "get status OK " do
      params = {
        username: "usertest",
        firstname: "fname",
        lastname: "lname",
        user_type: 1,
        password: "pass1",
        confirm_password: "pass1"
      }
      post :signup, params: params
      expect(response.status).to eq(200)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("Successful")
    end
  end 

  describe "LOGIN " do
    it "get status 400 due to name or password missing" do
      params = {
        username: "",
        password: "pass1"
      }
      post :login, params: params
      expect(response.status).to eq(401)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("name or password field is missing")
    end
    
    it "get status 400 due to name or password missing" do
      params = {
        username: "username",
        password: "pass1"
      }
      post :login, params: params
      expect(response.status).to eq(401)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("wrong name or password")
    end

    it "Login Successfully" do
      @user = create(:user, :username => "usertest", :password => "pass")
      params = {
        username: "usertest",
        password: "pass"
      }
      post :login, params: params
      expect(response.status).to eq(200)
      message = JSON.parse(response.body)['message']
      expect(message).to eq("logged in successfully")
    end
  end  
end