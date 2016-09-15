FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "name#{n}" }
    sequence(:age) { |n| n }
    admin_id nil

    to_create(&:save)
  end
end
