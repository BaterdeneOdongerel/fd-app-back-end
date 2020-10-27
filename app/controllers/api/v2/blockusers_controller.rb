class Api::V2::BlockusersController < ApplicationController
	before_action :authorized
	def create_or_update
		if params[:restaurant_id].present? && params[:user_id].present? && params.has_key?(:blocked)
			@buser = BlockedUser.where({
						:restaurant_id => params[:restaurant_id], 
						:user_id => params[:user_id]
					}).first
			if @buser
				@buser.blocked = params[:blocked]
			else 
				@buser = BlockedUser.new(
							:restaurant_id => params[:restaurant_id], 
							:user_id => params[:user_id],
							:blocked => params[:blocked]
							)
			end	
			@buser.save!
			render json: @buser
		else
			render status: 400, json: {message: "missing params"}
		end	
	end

	def fetch_users_by_restaurant
		count = params[:count].present? ? params[:count].to_i : 0
		per_page = params[:per_page].present? ? params[:per_page].to_i : 16
		@buser = BlockedUser.where({:restaurant_id => params[:restaurant_id]})
		hash = Hash.new
		@buser.each do |user|
			hash[user[:user_id]] = user[:blocked]
		end	
		@user = User.where({:user_type => 1}).map { |user|  get_merged_hash(user, hash) }.slice(count,per_page)
		render json: @user
	end	

	def get_merged_hash user, hash
		user_json = user.attributes
		if hash.has_key?(user.id)
			user_json.merge!(:blocked => hash[user.id])
		else
			user_json.merge!(:blocked => false)
		end	
		user_json.delete("password")
		user_json.delete("password_digest")
		user_json.delete("token")
		user_json
	end	
end
