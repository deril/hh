require 'spec_helper'

describe ImagesController do

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
    it "has success response" do
      get :show, { id: image.id }
      response.should be_success
    end
    it "has bad response if image does not exist" do
      expect {
        get :show, { id: 100500 }
      }.to raise_error
    end
    it "has img and tags variables" do
      get :show, { id: image.id }
      assigns(:img).should == image
      assigns(:tags).should =~ [tag_1, tag_2]
    end
  end

  describe "#about" do
    it "has just a good response" do
      get :about
      response.should be_success
    end 
  end
end