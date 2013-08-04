FactoryGirl.define do
  
  factory :image do
    image File.new(Rails.root + 'spec/fixtures/images/valid.jpeg')
  end
  
end