require 'spec_helper'

describe DispatchImgsController do
  
  let(:tagging) { FactoryGirl.create(:tagging) }
  let(:image) { tagging.taggable }
  let(:tag) { tagging.tag }

  describe 'GET "index"' do
    it "gets good response" do
      get :index
      assigns(:imgs).should == [image]
      response.should be_success
    end
  end

  describe 'GET "new"' do
    it 'gets good response' do
      get :new
      assigns(:img).should be_a_new(Image)
      assigns(:tags).should == [tag]
      response.should be_success
    end
  end

end
