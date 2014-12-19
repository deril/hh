require 'rails_helper'

describe Dispatch::GroupsController, type: :controller do

  before :each do
    admin = FactoryGirl.create(:admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  describe "#index" do
    let(:group1) { FactoryGirl.create(:group, name: 'A-g') }
    let(:group2) { FactoryGirl.create(:group, name: 'Z-g') }

    it "finds group of group" do
      get :index
      expect(assigns(:groups)).to eq([group1, group2])
    end
    it "response success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "#new" do
    it "response success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    let(:group1) { FactoryGirl.create(:group, name: 'A-g') }

    it 'response redirect if all good' do
      post :create, { group: { name: " some Action " }  }
      expect(response).to redirect_to dispatch_groups_path
      expect(flash[:notice]).to eq("Group was successfully created")
    end
    it "response renders new if fail" do
      post :create
      expect(response).to render_template "new"
    end
    it 'has correct group' do
      post :create, { group: { name: "some Action", group_id: group1.id } }
      expect(assigns(:group).name).to eq("Some action")
      expect(assigns(:group).group_id).to eq(group1.id)
    end
    it 'adds new group into db' do
      expect {
        post :create, { group: { name: " some Action " } }
      }.to change(Group, :count).by(1)
    end
  end

  describe "#edit" do
    let(:group1) { FactoryGirl.create(:group, name: 'A-g') }
    let(:tag) { FactoryGirl.create(:orphan_tag) }

    it "has response success" do
      get :edit, { id: group1.id }
      expect(response).to be_success
    end
    it "has current group" do
      get :edit, { id: group1.id }
      expect(assigns(:group)).to eq(group1)
      expect(assigns(:tags)).to eq([tag])
    end
    it "redirects on index if group not found" do
      get :edit, { id: 0 }
      expect(response).to redirect_to dispatch_groups_path
      expect(flash[:alert]).to eq('Cannot find such group')
    end
  end

  describe "#update" do
    let(:group1) { FactoryGirl.create(:group, name: 'A-g') }
    let(:group2) { FactoryGirl.create(:group, name: 'Z-g') }

    it "response redirect if all good" do
      put :update, { id: group1.id, group: { name: "some New Action", group_id: group2.id } }
      expect(response).to redirect_to dispatch_groups_path
      expect(flash[:notice]).to eq("Group was successfully updated")
    end

    it "has variables" do
      put :update, { id: group1.id, group: { name: "some New Action", group_id: group2.id } }
      expect(assigns(:group)).to eq(group1)
      expect(assigns(:group).name).to eq("Some new action")
      expect(assigns(:group).group_id).to eq(group2.id)
    end

    it "response renders edit if fail" do
      put :update, { id: group1.id, group: { name: nil } }
      expect(response).to be_successful
      expect(response).to render_template "edit"
    end

    it "redirects on index if group not found" do
      put :update, { id: 0 }
      expect(response).to redirect_to dispatch_groups_path
      expect(flash[:alert]).to eq('Cannot find such group')
    end
  end

  describe "#destroy" do
    let!(:group1) { FactoryGirl.create(:group, name: 'A-g') }

    it "response redirect if all good" do
      delete :destroy, { id: group1.id }
      expect(response).to redirect_to dispatch_groups_path
      expect(flash[:notice]).to eq("Group was successfully deleted")
    end

    it "deletes group" do
      expect {
        delete :destroy, { id: group1.id }
      }.to change(Group, :count).by(-1)
    end

    it "redirects on index if group not found" do
      delete :destroy, { id: 0 }
      expect(response).to redirect_to dispatch_groups_path
      expect(flash[:alert]).to eq('Cannot find such group')
    end

    it 'nullify all tags in deleted group' do
      group3 = FactoryGirl.create(:group_with_tags)
      tag = group3.tags.first
      expect(tag.group_id).to eq(group3.id)

      delete :destroy, id: group3.id
      expect(tag.reload.group_id).to eq(nil)
    end
  end

end
