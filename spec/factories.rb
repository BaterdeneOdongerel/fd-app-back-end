FactoryBot.define do
  factory :user do
    username {"testuser1"}
    password {"pass"}
    lastname {"lastname1"}
    firstname {"firstname1"}
    user_type {2}
  end
  
  factory :restaurant do
    name {"restaurant1"}
    description {"description1"}
    association :user
    hide {0}
  end
  
  factory :meal do
    name {"meal1"}
    description {"description1"}
    price {15.5}
    association :restaurant
  end

  factory :order do 
    association :user
    association :restaurant
    status {1}
    total {100}
  end  

  factory :order_meal do 
    association :order
    association :meal 
    amount {5}
  end 

  factory :blocked_user do 
    association :restaurant
    association :user
    blocked {true}
  end 
end
