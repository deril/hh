FactoryGirl.define do
  factory :images_tag, class: "ImagesTag" do
    image { FactoryGirl.create(:image) }
    tag { FactoryGirl.create(:orphan_tag) }
  end
end