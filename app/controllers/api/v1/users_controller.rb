class Api::V1::UsersController < ApplicationController
	
	def signup
		result = sign_able params
		if result[:valid]
			@user = User.new( 
				:username => params[:username],
			  	:lastname => params[:lastname],
			  	:firstname => params[:firstname],
			  	:password => params[:password],
			  	:user_type => params[:user_type]
		  	)
		  	@user.save!
		  	if @user.valid? 
		  		render json: { :message => "Successful", :valid => true}
		  	else
				render status: 400, json: { :message => "Unsuccessful", :valid => false}
		  	end	
		else
			render status: 400, json: result
		end	
	end

	def login
		if params[:username].present? && params[:password].present?
			@user = User.find_by(username: params[:username])
			if @user && @user.authenticate(params[:password])
				token = encode_token({user_id: @user.id , time: (Time.now.to_f * 1000).to_i})
				@user.token = token
				@user.save!
				render json: { 
					:message => "logged in successfully", 
					token: token, 
					user: @user.as_json(:except => [:password_digest, :token ])
				}
			else 
				render status: 401, json: { :message => "wrong name or password" }
			end
		else
			render status: 401, json: { :message => "name or password field is missing" }
		end
	end

	def logout
		unless params[:id].present?
			render status: 401
			return
		end
		@user = User.find_by(id: params[:id])
		if @user == nil
			render status: 400
			return
		end	
		@user.token = nil
		if @user.save!
			render status: 200
		else 
			render status: 400
		end	
	end	

	
	def sign_able param 
		unless param[:username].present?
			return { :message => "username is missing", :valid => false}
		end
		unless param[:lastname].present?
			return { :message => "lastname is missing", :valid => false}
		end
		unless param[:firstname].present?
			return { :message => "firstname is missing", :valid => false}
		end
		unless param[:user_type].present?
			return { :message => "type is missing", :valid => false}
		end
		unless param[:password].present?
			return { :message => "password is missing", :valid => false}
		end
		unless param[:confirm_password].present?
			return { :message => "confirm password is missing", :valid => false}
		end
		if (param[:confirm_password] != param[:password]) 
			return { :message => "password doesn't match", :valid => false}
		end	
		user = User.where({ username: param[:username] })
		if user.length > 0
			return { :message => "username already exists", :valid => false}
		end
		return { :message => "successful", :valid => true }
	end
end
