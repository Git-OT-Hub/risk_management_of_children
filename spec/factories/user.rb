FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "P@ssw0rd" }
    password_confirmation { "P@ssw0rd" }
  end

  trait :with_avatar do
    after(:build) do |user|
      user.avatar.attach(io: File.open("spec/fixtures/test1.png"), filename: "test1.png", content_type: "image/png")
    end
  end
end
