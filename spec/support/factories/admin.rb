FactoryGirl.define do
  factory :admin do
    sequence(:name) { |n| "name#{n}" }
    sequence(:age) { |n| n }
    sequence(:email) { |n| "email#{n}@gmail.com" }

    to_create(&:save)
  end
end
