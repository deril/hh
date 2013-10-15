FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| Faker::Lorem.word + n.to_s }

    factory :group_with_tags do
      tags { |tag| [tag.association(:orphan_tag)] }
    end
  end
end