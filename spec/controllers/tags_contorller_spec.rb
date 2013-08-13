require 'spec_helper'

describe TagsController do

  let(:custom_tag) { FactoryGirl.create(:tag) }
  let(:tag) { FactoryGirl.create(:tag) }
  let!(:image) { FactoryGirl.create(:image, tags: [custom_tag, tag]) }

  describe "#index" do
    it "has respond success and has tags variable" do
      get :index
      assigns(:tags).should == [custom_tag, tag]
      response.should be_success
    end
  end

  describe "#show" do
    it "has respond success" do
      get :show, { id: tag.id }
      response.should be_success
    end 
    it "has an Exception id cur_tag is undefined" do
      expect {
        get :show, { id: 100500 }
      }.to raise_error
    end
    it "has cur_tag and images variable" do
      get :show, { id: tag.id }
      assigns(:cur_tag).should == tag
      assigns(:imgs).should == [image]
    end
    it "has tags variable, what has no cur_tag, but all others of images" do
      get :show, { id: tag.id }
      assigns(:tags).should == [custom_tag]
    end
    it "has no tags variable at all, if cur_tag.images is empty" do
      get :show, { id: tag.id }
      assigns(:tags).include?(tag).should == false
    end 
  end


end