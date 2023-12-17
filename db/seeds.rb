10.times do
  User.create!(
    name: Faker::Name.unique.name,
    email: Faker::Internet.unique.email,
    password: "P@ssw0rd",
    password_confirmation: "P@ssw0rd"
  )
end

20.times do |n|
  Post.create!(
    user: User.offset(rand(User.count)).first, 
    title: "タイトル#{n}", 
    body: "本文#{n}"
  )
end
