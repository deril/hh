require 'rails_helper'

describe Dispatch::TagsController, type: :controller do

  before :each do
    admin = FactoryGirl.create(:admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  describe "#index" do
    let(:tag1) { FactoryGirl.create(:orphan_tag, name: "A_first") }
    let(:tag2) { FactoryGirl.create(:orphan_tag, name: "Z_last") }

    it "finds group of tags" do
      get :index
      expect(assigns(:tags)).to eq([tag1, tag2])
    end
    it "response success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "#new" do
    let!(:group) { FactoryGirl.create(:group) }

    it "response success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    let(:group) { FactoryGirl.create(:group) }

    it 'response redirect if all good' do
      post :create, { tag: { name: " some_Action " }  }
      expect(response).to redirect_to dispatch_tags_path
      expect(flash[:notice]).to eq("Tag was successfully created")
    end

    it "response renders new if fail" do
      post :create
      expect(response).to render_template "new"
    end

    it 'has correct tag name & group' do
      post :create, { tag: { name: " some_Action ", group_id: group.id } }
      expect(assigns(:tag).name).to eq("Some action")
      expect(assigns(:tag).group_id).to eq(group.id)
    end

    it 'adds new tag into db' do
      expect {
        post :create, { tag: { name: " some_Action " } }
      }.to change(Tag, :count).by(1)
    end
  end

  describe "#edit" do
    let(:tag1) { FactoryGirl.create(:orphan_tag, name: "A_first") }
    let(:group) { FactoryGirl.create(:group) }

    it "has response success" do
      get :edit, { id: tag1.id }
      expect(response).to be_success
    end

    it "has current tag" do
      get :edit, { id: tag1.id }
      expect(assigns(:tag)).to eq(tag1)
      expect(assigns(:groups)).to eq([group])
    end

    it "redirects on index if tag not found" do
      get :edit, { id: 0 }
      expect(response).to redirect_to dispatch_tags_path
      expect(flash[:alert]).to eq("Can't find such Tag.")
    end
  end

  describe "#update" do
    let(:tag1) { FactoryGirl.create(:orphan_tag, name: "A_first") }
    let(:group) { FactoryGirl.create(:group) }

    it "response redirect if all good" do
      put :update, { id: tag1.id, tag: { name: " some_New  Action ", group_id: group.id } }
      expect(assigns(:tag)).to eq(tag1)
      expect(assigns(:tag).name).to eq("Some new action")
      expect(assigns(:tag).group_id).to eq(group.id)
      expect(response).to redirect_to dispatch_tags_path
      expect(flash[:notice]).to eq("Tag was successfully updated")
    end

    it "response renders edit if fail" do
      put :update, { id: tag1.id, tag: { name: nil } }
      expect(response).to be_success
      expect(response).to render_template "edit"
    end

    it "redirects on index if tag not found" do
      put :update, { id: 0 }
      expect(response).to redirect_to dispatch_tags_path
      expect(flash[:alert]).to eq("Can't find such Tag.")
    end
  end

  describe "#destroy" do
    let!(:tag1) { FactoryGirl.create(:orphan_tag, name: "A_first") }

    it "response redirect if all good" do
      delete :destroy, { id: tag1.id }
      expect(response).to redirect_to dispatch_tags_path
      expect(flash[:notice]).to eq("Tag successfully Deleted.")
    end

    it "deletes tag" do
      expect { delete :destroy, { id: tag1.id } }.to change(Tag, :count).by(-1)
    end

    it "redirects on index if tag not found" do
      delete :destroy, { id: 0 }
      expect(response).to redirect_to dispatch_tags_path
      expect(flash[:alert]).to eq("Can't find such Tag.")
    end
  end


end
