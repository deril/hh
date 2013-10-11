require 'spec_helper'

describe DispatchImgsController do
  
  let!(:tagging) { FactoryGirl.create(:images_tag) }
  let(:image) { tagging.image }
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
      response.should be_success
    end
    it 'has assigns' do
      get :new
      assigns(:img).should be_a_new(Image)
      assigns(:tags).should == [tag]
    end
  end

end
