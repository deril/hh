# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "test#{n}@test.test" }
    password "12345678"
    password_confirmation {|u| u.password}
  end
end
