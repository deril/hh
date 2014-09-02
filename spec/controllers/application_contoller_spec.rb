require 'rails_helper'

describe ApplicationController, :type => :controller do

  let(:image_1) { FactoryGirl.create(:image) }
  let(:image_2) { FactoryGirl.create(:image) }
  let(:controller) { ApplicationController.new() }

  describe "#get_uniq_tags_from" do
    describe "if except_tag not included" do
      it "gets all tags of images" do 
        result = controller.get_uniq_tags_from([image_1, image_2])
        etalon = image_1.tags + image_2.tags
        result.should == etalon 
      end
    end

    describe "if except_tag included" do
      it "gets all tags of images except current" do
        result = controller.get_uniq_tags_from([image_1, image_2], image_1.tags.first)
        etalon = image_1.tags + image_2.tags 
        etalon.delete(image_1.tags.first)
        result.should == etalon 
      end
    end
  end

  describe 'hh_authenticate_admin!' do
    it 'raises error if admin is not logged in' do
      expect { visit '/dispatch/imgs/' }.to raise_error(ActionController::RoutingError)
    end
  end

end
