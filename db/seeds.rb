# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(username: "user1", password: "pass1", lastname: "dorj1", firstname: "gotov1", user_type: 1)
user2 = User.create(username: "user2", password: "pass2", lastname: "dorj2", firstname: "gotov2", user_type: 1)
user3 = User.create(username: "user3", password: "pass3", lastname: "dorj3", firstname: "gotov3", user_type: 2)
user4 = User.create(username: "user4", password: "pass4", lastname: "dorj4", firstname: "gotov4", user_type: 2)



r1 = Restaurant.create(name: "Restaurant1" , description: " mongol hool" , user_id: user1.id)
r2 = Restaurant.create(name: "Restaurant2" , description: " japan hool" , user_id: user1.id)
r3 = Restaurant.create(name: "Restaurant3" , description: " italy hool" , user_id: user1.id)
r4 = Restaurant.create(name: "Restaurant4" , description: " Turkish hool" , user_id: user2.id)

m1 = Meal.create(restaurant_id: r1.id, name: "hool1" , description: "desc hool 1", price: 15)
m2 = Meal.create(restaurant_id: r1.id, name: "hool2" , description: "desc hool 2", price: 1.4)
m3 = Meal.create(restaurant_id: r1.id, name: "hool3" , description: "desc hool 3", price: 23.3)
m4 = Meal.create(restaurant_id: r2.id, name: "hool4" , description: "desc hool 4", price: 10.6)
m5 = Meal.create(restaurant_id: r2.id, name: "hool5" , description: "desc hool 5", price: 9.90)
m6 = Meal.create(restaurant_id: r3.id, name: "hool6" , description: "desc hool 6", price: 8.75)
m7 = Meal.create(restaurant_id: r4.id, name: "hool7" , description: "desc hool 7", price: 5.5)
m8 = Meal.create(restaurant_id: r4.id, name: "hool8" , description: "desc hool 8", price: 12.5)

b1 = Meal.create(restaurant_id: r4.id, user_id: user4.id)

