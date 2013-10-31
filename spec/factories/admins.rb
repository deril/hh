# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    email "test@test.test"
    password "12345678"
    password_confirmation {|u| u.password}
  end
end
