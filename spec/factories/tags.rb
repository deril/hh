FactoryGirl.define do
  factory :tag do
    group
    name { Faker::Lorem.word }
  end
end
