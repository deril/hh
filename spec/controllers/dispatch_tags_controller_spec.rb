require 'spec_helper'

describe DispatchTagsController do

  let!(:admin) { FactoryGirl.create(:admin) }  
  let!(:tag1) { FactoryGirl.create(:tag, name: "A_first") }
  let!(:tag2) { FactoryGirl.create(:tag, name: "Z_last") }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  describe "#index" do
    it "finds group of tags" do
      get :index 
      assigns(:tags).should == [tag1, tag2]
    end
    it "response success" do
      get :index 
      response.should be_success
    end
  end

  describe "#new" do
    it "response success" do
      get :new 
      response.should be_success
    end
  end

  describe "#create" do
    it 'response redirect if all good' do
      post :create, { tag: " some Action " }
      response.should redirect_to dispatch_tags_path
      flash[:notice].should == "Tag successfully Saved."
    end

    it "response redirect if fail" do
      post :create, {}
      response.should redirect_to dispatch_tags_path
      flash[:alert].should == "Something bad with tag Saving."
    end

    it 'has correct tag name' do
      post :create, { tag: " some Action " }
      assigns(:tag).name.should == "some_action"
    end

    it 'adds new tag into db' do
      expect {
        post :create, { tag: " some Action " }
      }.to change(Tag, :count).by(1)
    end
  end

  describe "#edit" do
    it "has response success" do
      get :edit, { id: tag1.id }
      response.should be_success
    end

    it "has current tag" do
      get :edit, { id: tag1.id }
      assigns(:tag).should == tag1
    end

    it "redirects on index if tag not found" do
      get :edit, { id: 0 }
      response.should redirect_to dispatch_tags_path
      flash[:alert].should == Tag.not_found[:alert]
    end
  end

  describe "#update" do
    it "response redirect if all good" do
      put :update, { id: tag1.id, tag: " some New  Action " }
      response.should redirect_to dispatch_tags_path
      flash[:notice].should == "Tag successfully Saved."
    end

    it "response redirect if fail" do 
      put :update, { id: tag1.id }
      response.should redirect_to dispatch_tags_path
      flash[:alert].should == "Something bad with tag Saving."
    end

    it "has correct tag name" do
      put :update, { id: tag1.id, tag: " some New  Action " } 
      assigns(:tag).should == tag1 
      assigns(:tag).name.should == "some_new_action"
    end

    it "redirects on index if tag not found" do
      put :update, { id: 0 }
      response.should redirect_to dispatch_tags_path
      flash[:alert].should == Tag.not_found[:alert] 
    end
  end

  describe "#destroy" do
    it "response redirect if all good" do
      delete :destroy, { id: tag1.id }
      response.should redirect_to dispatch_tags_path
      flash[:notice].should == "Tag successfully Deleted."
    end
    
    it "deletes tag" do
      expect { 
        delete :destroy, { id: tag1.id }
      }.to change(Tag, :count).by(-1)
    end

    it "redirects on index if tag not found" do
      delete :destroy, { id: 0 }
      response.should redirect_to dispatch_tags_path
      flash[:alert].should == Tag.not_found[:alert]
    end
  end


end
