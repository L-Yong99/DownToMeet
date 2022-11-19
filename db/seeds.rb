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
  email: "lincoln@gmail.com",
  first_name: "Lincoln",
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
  address: "Sentul Cres, Singapore 821313",
  date: Date.today,
  time: Time.now,
  private: true,
  category: category.sample,
  user: user1
)

event2 = Event.create!(
  name: Faker::Hobby.activity,
  detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  spots: rand(1..10).floor,
  address: "2 Ang Mo Kio Dr, Singapore 567720",
  date: Date.today,
  time: Time.now,
  private: true,
  category: category.sample,
  user: user1
)

event3 = Event.create!(
  name: Faker::Hobby.activity,
  detail: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  spots: rand(1..10).floor,
  address: "80 Mandai Lake Rd, 729826",
  date: Date.new(2022,11,27),
  time: Time.now,
  private: true,
  category: category.sample,
  user: user2
)

event4 = Event.create!(
  name: "Outdoor camping",
  detail: "camping together is fun",
  spots: 10,
  address: "1110 ECP, Singapore 449880",
  date: Date.new(2022,11,27),
  time: Time.now,
  private: true,
  category: "Camping",
  user: user3
)

event5 = Event.create!(
  name: "Outdoor Adventure 2D1N",
  detail: "Come along, for an adventure",
  spots: 35,
  address: "Nicoll Dr, Singapore 498991",
  date: Date.new(2022,11,27),
  time: Time.now,
  private: true,
  category: "Adventure",
  user: user3
)

event6 = Event.create!(
  name: "Outdoor Frontier",
  detail: "Challenge yourself!",
  spots: 8,
  address: "4 Tampines Central 5, Singapore 529510",
  date: Date.new(2022,11,27),
  time: Time.now,
  private: true,
  category: "challenges",
  user: user3
)
