FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "タイトル#{n}" }
    sequence(:body) { |n| "本文#{n}" }
    association :user
  end

  trait :with_image do
    after(:build) do |post|
      post.images.attach(io: File.open("spec/fixtures/test1.png"), filename: "test1.png", content_type: "image/png")
    end
  end
end
