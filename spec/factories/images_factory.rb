FactoryGirl.define do
  factory :image do
    image File.new(Rails.root + 'spec/fixtures/images/valid.jpeg')

    factory :image_with_tags do
      tags {|t| [t.association(:tag)]}
    end
  end
end
