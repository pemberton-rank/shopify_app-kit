FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.io" }
    password 'password'
  end

  factory :shop do
  end
end
