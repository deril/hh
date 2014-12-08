require 'rails_helper'

describe ApplicationController, type: :controller do

  let(:image_1) { FactoryGirl.create(:image) }
  let(:image_2) { FactoryGirl.create(:image) }
  let(:controller) { ApplicationController.new() }

  describe "#get_uniq_tags_from" do
    context "if except_tag not included" do
      it "gets all tags of images" do
        args = [image_1, image_2]
        etalon = image_1.tags + image_2.tags
        expect(controller.get_uniq_tags_from(args)).to eq(etalon)
      end
    end

    context "if except_tag included" do
      it "gets all tags of images except current" do
        args = [image_1, image_2]
        etalon = image_1.tags + image_2.tags
        etalon.delete(image_1.tags.first)
        expect(controller.get_uniq_tags_from(args, image_1.tags.first)).to eq(etalon)
      end
    end
  end

  describe 'hh_authenticate_admin!' do
    it 'raises error if admin is not logged in' do
      expect { visit '/dispatch/imgs/' }.to raise_error(ActionController::RoutingError)
    end
  end

end
