Rails.application.routes.draw do
	namespace :api do
	  namespace :v1 do
	  	#resources :users, :only => [:index, :show]
	  	#get 'users', :to => 'users#index'
	  	post 'users/login', :to => 'users#login'
	  	get 'users/logout', :to => 'users#logout'
	  	post 'users/signup', :to => 'users#signup'
	  	get 'users/auto_login', :to => 'users#auto_login'


	  	resources :restaurants do
	  	  collection do
 			get '/fetch_single_restaurant', :to => 'restaurants#fetch_single_restaurant'
  		  end
	  	end
        
        resources :orders do
	  	  collection do
    		post '/update_order', :to => 'orders#update_order'
    		get '/show_user_order', :to => 'orders#show_user_order'
    		
  		  end
	  	end

	  	 resources :meals do
	  	  collection do
  		  end
	  	end
	  	resources :blockusers do
	  	  collection do
    
  		  end
	  	end

	  end	

	   namespace :v2 do
	  	resources :restaurants do
	  	  collection do
	  	  	get '/fetch_single_restaurant', :to => 'restaurants#fetch_single_restaurant'
	  	  	post '/update', :to => 'restaurants#update'
	  	  	post '/delete_restaurant', :to => 'restaurants#delete_restaurant'
  		  end
	  	end
        
        resources :orders do
	  	  collection do
    		post '/update_order', :to => 'orders#update_order'
    		get '/show_owner_order', :to => 'orders#show_owner_order'
  		  end
	  	end

	  	 resources :meals do
	  	  collection do
	  	  	get '/fetch_single_meal', :to => 'meals#fetch_single_meal'
	  	  	post '/update', :to => 'meals#update'
	  	  	post '/delete_meal', :to => 'meals#delete_meal'
  		  end
	  	end
	  	resources :blockusers do
	  	  collection do
	  	  	get '/fetch_users_by_restaurant', :to => 'blockusers#fetch_users_by_restaurant'
	  	  	post '/create_or_update', :to => 'blockusers#create_or_update'
  		  end
	  	end
	  end	


	end	
end
