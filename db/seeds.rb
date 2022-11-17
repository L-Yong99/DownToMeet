# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Attendance.destroy_all
User.destroy_all
Event.destroy_all
category = %w(sports games coding mingle movies)

user1 = User.create!(
  email: "malcolm@gmail.com",
  first_name: "Malcolm",
  last_name: "The Rich",
  password: "123456"
)

user2 = User.create!(
  email: "janlosthisphone@yahoo.com",
  first_name: "Jan",
  last_name: "Losthisphone",
  password: "123456"
)

user3 = User.create!(
  email: "hien.was.eaten.by.flora@gmail.com",
  first_name: "Hien",
  last_name: "Flora",
  password: "123456"
)

user4 = User.create!(
  email: "kkkk@gmail.com",
  first_name: "kh",
  last_name: "hhhx",
  password: "123456"
)

user5 = User.create!(
  email: "xxxx@gmail.com",
  first_name: "xxx",
  last_name: "hhhx",
  password: "123456"
)

event1 = Event.create!(
  name: Faker::Hobby.activity,
  detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  spots: rand(1..10).floor,
  address: Faker::Address.street_name,
  date: Faker::Date.forward(days: 23),
  time: Faker::Time.forward(days: 23, period: :morning),
  private: true,
  category: category.sample,
  user:user1
)

event2 = Event.create!(
  name: Faker::Hobby.activity,
  detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  spots: rand(1..10).floor,
  address: Faker::Address.street_name,
  date: Faker::Date.forward(days: 23),
  time: Faker::Time.forward(days: 23, period: :morning),
  private: true,
  category: category.sample,
  user:user2
)
# puts event1
