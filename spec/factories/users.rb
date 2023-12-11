FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "user_#{n}"}
    sequence(:email) {|n| "user_#{n}@example.com"}
    password {"P@ssw0rd"}
    password_confirmation {"P@ssw0rd"}
  end
end
