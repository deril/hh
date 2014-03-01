require 'spec_helper'

describe Dispatch::TagsController do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:tag1) { FactoryGirl.create(:orphan_tag, name: "A_first") }
  let!(:tag2) { FactoryGirl.create(:orphan_tag, name: "Z_last") }
  let!(:group) { FactoryGirl.create(:group) }

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
      post :create, { tag: { name: " some_Action " }  }
      response.should redirect_to dispatch_tags_path
      flash[:notice].should == "Tag was successfully created"
    end

    it "response renders new if fail" do
      post :create
      response.should render_template "new"
    end

    it 'has correct tag name & group' do
      post :create, { tag: { name: " some_Action ", group_id: group.id } }
      assigns(:tag).name.should == "Some action"
      assigns(:tag).group_id.should == group.id
    end

    it 'adds new tag into db' do
      expect {
        post :create, { tag: { name: " some_Action " } }
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
      assigns(:groups).should == [group]
    end

    it "redirects on index if tag not found" do
      get :edit, { id: 0 }
      response.should redirect_to dispatch_tags_path
      flash[:alert].should == Tag.not_found[:alert]
    end
  end

  describe "#update" do
    it "response redirect if all good" do
      put :update, { id: tag1.id, tag: { name: " some_New  Action ", group_id: group.id } }
      assigns(:tag).should == tag1
      assigns(:tag).name.should == "Some new action"
      assigns(:tag).group_id.should == group.id
      response.should redirect_to dispatch_tags_path
      flash[:notice].should == "Tag was successfully updated"
    end

    it "response renders edit if fail" do
      put :update, { id: tag1.id, tag: { name: nil } }
      response.should be_successful
      response.should render_template "edit"
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
