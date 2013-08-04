FactoryGirl.define do
  
  factory :image do
    image File.new(Rails.root + 'spec/fixtures/images/valid.jpeg')
    tags {[FactoryGirl.create(:tag)]}
  end
  
end