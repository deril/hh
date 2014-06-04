require 'rails_helper'

describe Dispatch::GroupsController, :type => :controller do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:group1) { FactoryGirl.create(:group, name: 'A-g') }
  let!(:group2) { FactoryGirl.create(:group, name: 'Z-g') }
  let!(:tag) { FactoryGirl.create(:orphan_tag) }

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  describe "#index" do
    it "finds group of group" do
      get :index
      assigns(:groups).should == [group1, group2]
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
      post :create, { group: { name: " some Action " }  }
      response.should redirect_to dispatch_groups_path
      flash[:notice].should == "Group was successfully created"
    end

    it "response renders new if fail" do
      post :create
      response.should render_template "new"
    end

    it 'has correct group' do
      post :create, { group: { name: "some Action", group_id: group1.id } }
      assigns(:group).name.should == "Some action"
      assigns(:group).group_id.should == group1.id
    end

    it 'adds new group into db' do
      expect {
        post :create, { group: { name: " some Action " } }
      }.to change(Group, :count).by(1)
    end
  end

  describe "#edit" do
    it "has response success" do
      get :edit, { id: group1.id }
      response.should be_success
    end

    it "has current group" do
      get :edit, { id: group1.id }
      assigns(:group).should == group1
      assigns(:tags).should == [tag]
    end

    it "redirects on index if group not found" do
      get :edit, { id: 0 }
      response.should redirect_to dispatch_groups_path
      flash[:alert].should == 'Cannot find such group'
    end
  end

  describe "#update" do
    it "response redirect if all good" do
      put :update, { id: group1.id, group: { name: "some New Action", group_id: group2.id } }
      assigns(:group).should == group1
      assigns(:group).name.should == "Some new action"
      assigns(:group).group_id.should == group2.id
      response.should redirect_to dispatch_groups_path
      flash[:notice].should == "Group was successfully updated"
    end

    it "response renders edit if fail" do
      put :update, { id: group1.id, group: { name: nil } }
      response.should be_successful
      response.should render_template "edit"
    end

    it "redirects on index if group not found" do
      put :update, { id: 0 }
      response.should redirect_to dispatch_groups_path
      flash[:alert].should == 'Cannot find such group'
    end
  end

  describe "#destroy" do
    it "response redirect if all good" do
      delete :destroy, { id: group1.id }
      response.should redirect_to dispatch_groups_path
      flash[:notice].should == "Group was successfully deleted"
    end

    it "deletes group" do
      expect {
        delete :destroy, { id: group1.id }
      }.to change(Group, :count).by(-1)
    end

    it "redirects on index if group not found" do
      delete :destroy, { id: 0 }
      response.should redirect_to dispatch_groups_path
      flash[:alert].should == 'Cannot find such group'
    end

    it 'nullify all tags in deleted group' do
      group3 = FactoryGirl.create(:group_with_tags)
      tag = group3.tags.first
      tag.group_id.should == group3.id
      delete :destroy, id: group3.id
      tag.reload.group_id.should == nil
    end
  end


end
