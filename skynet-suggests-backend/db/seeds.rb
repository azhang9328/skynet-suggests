# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
u1 = User.create(name: "Allen")
u2 = User.create(name: "Eli")

r1 = Repo.create(nickname: "TestRepo1", url: "https://github.com/azhang9328/skynet-suggests", user_id: u1.id, bundle_id: "gh/azhang9328/skynet-suggests/029cb96c7feea13d08c088ff5cc234208781cbc1")
r2 = Repo.create(nickname: "TestRepo2", url: "https://github.com/azhang9328/skynet-suggests", user_id: u1.id, bundle_id: "gh/azhang9328/skynet-suggests/029cb96c7feea13d08c088ff5cc234208781cbc1")
r3 = Repo.create(nickname: "RandomRepo", url: "https://github.com/moviemasher/moviemasher.js", user_id: u1.id)
r4 = Repo.create(nickname: "Christina", url: "https://github.com/christinamcmahon/travel-pin", user_id: User.first.id, bundle_id: "gh/christinamcmahon/travel-pin/a5ed7ad95d82842e9f3fe4933c15982d35ad07a2")

