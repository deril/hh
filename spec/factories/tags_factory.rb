FactoryGirl.define do
  factory :tag do
    group
    name { Faker::Lorem.word + rand(1000).to_s }
  end
end
