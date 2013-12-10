FactoryGirl.define do
  factory :warn, class: Tag do
    name Faker::Lorem.word
  end
end
