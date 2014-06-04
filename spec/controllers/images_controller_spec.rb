require 'rails_helper'

describe ImagesController, :type => :controller do

  let(:tag_1) { FactoryGirl.create(:tag) }
  let(:tag_2) { FactoryGirl.create(:tag) }
  let!(:image) { FactoryGirl.create(:image, tags: [tag_1, tag_2]) }

  describe "#index" do 
    it "has success response" do 
      get :index
      response.should be_success
    end
    it "has imgs and tags variables" do
      get :index
      assigns(:imgs).should == [image]
      assigns(:tags).should =~ [tag_1, tag_2]
    end
  end

  describe "#show" do
    it "has response redirect if tag not found" do
      get :show, { id: 0 }
      response.should redirect_to(images_path)
      flash[:alert].should == Image.not_found[:alert]
    end
    it "has success response" do
      get :show, { id: image.id }
      response.should be_success
    end
    it "has img and tags variables" do
      get :show, { id: image.id }
      assigns(:img).should == image
      assigns(:tags).should =~ [tag_1, tag_2]
    end
  end
end