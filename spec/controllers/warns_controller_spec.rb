require 'spec_helper'

describe WarnsController do

  let(:tag) { FactoryGirl.create(:tag) }
  let(:image) { FactoryGirl.create(:image, tags: [tag]) }
  let(:warn) { FactoryGirl.create(:warn, images: [image]) }

  describe "GET 'show'" do
    it "responses redirect if not found" do
      get :show, { id: 0 }
      response.should redirect_to(root_path)
      flash[:alert].should == 'Warn not found'
    end
    it "responds success" do
      get :show, { id: warn.id }
      response.should be_success
    end 
    it "has warn, images and tags variables" do
      get :show, { id: warn.id }
      assigns(:warn).should == warn
      assigns(:imgs).should == [image]
      assigns(:tags).should == [tag]
    end
  end

end
