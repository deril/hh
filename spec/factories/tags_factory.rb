FactoryGirl.define do
  factory :orphan_tag, class: Tag do
    sequence(:name) { |n| Faker::Lorem.word + n.to_s }

    factory :tag do
      group
    end
  end
end
