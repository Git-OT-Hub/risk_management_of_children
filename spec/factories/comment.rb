FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "本文#{n}" }
    association :user
    association :post
  end

  trait :with_comment_image do
    after(:build) do |comment|
      comment.comment_image.attach(io: File.open("spec/fixtures/test1.png"), filename: "test1.png", content_type: "image/png")
    end
  end
end
