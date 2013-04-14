FactoryGirl.define do
  
  factory :image do
    image File.new(Rails.root + 'spec/fixtures/images/valid.jpeg')
  end

  factory :tag, class: ActsAsTaggableOn::Tag do
    name { Faker::Name.first_name }
  end

  factory :tagging, class: ActsAsTaggableOn::Tagging do
    association :tag, factory: :tag
    association :taggable, factory: :image
    context "tags"
  end
  
end