require 'rails_helper'

describe Dispatch::ImgsController, type: :controller do
  before :each do
    admin = FactoryGirl.create(:admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  describe 'GET "index"' do
    let(:tagging) { FactoryGirl.create(:images_tag) }
    let(:image) { tagging.image }

    it "gets good response" do
      get :index
      expect(assigns(:imgs)).to eq([image])
      expect(response).to be_success
    end
  end

  describe 'GET "new"' do
    let!(:tagging) { FactoryGirl.create(:images_tag) }
    let(:tag) { tagging.tag }

    it 'gets good response' do
      get :new
      expect(response).to be_success
    end

    it 'has assigns' do
      get :new
      expect(assigns(:img)).to be_a_new(Image)
      expect(assigns(:tags)).to eq(Tag.order("name ASC"))
      expect(assigns(:warns)).to eq(Warn.all.load())
    end
  end

  describe 'POST "create"' do
    let!(:tagging) { FactoryGirl.create(:images_tag) }
    let(:file_fixture) { fixture_file_upload('/images/valid.jpeg', 'image/jpeg') }

    it "response redirect if all good" do
      post :create, image: { image: file_fixture }
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:notice]).to eq("Image was successfully created")
    end

    it "response renders new if fail" do
      post :create
      expect(response).to render_template "new"
    end

    it "adds new image into db" do
      expect {
        post :create, { image: { image: file_fixture } }
      }.to change(Image, :count).by(1)
    end

    it "adds new images_tags into db" do
      tid = Tag.last.id.to_s
      expect {
        post :create, { image: { image: file_fixture, tag_ids: [tid] } }
      }.to change(ImagesTag, :count).by(1)
    end
  end

  describe 'GET "edit"' do
    let(:tagging) { FactoryGirl.create(:images_tag) }
    let(:image) { tagging.image }
    let!(:warn) { FactoryGirl.create(:warn) }

    it 'gets good response' do
      get :edit, { id: image.id }
      expect(response).to be_success
    end

    it 'has assigns' do
      get :edit, { id: image.id }
      expect(assigns(:img)).to eq(image)
      expect(assigns(:tags)).to eq(Tag.order("name ASC"))
      expect(assigns(:warns)).to eq(Warn.all.load())
    end

    it "redirects on index if tag not found" do
      get :edit, { id: 0 }
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:alert]).to eq("Can't find such Image.")
    end
  end

  describe 'PUT update' do
    let(:tagging) { FactoryGirl.create(:images_tag) }
    let(:image) { tagging.image }
    let(:file_uploaded) { fixture_file_upload('/images/uploaded.jpeg', 'image/jpeg') }

    it "response redirects if all good" do
      put :update, { id: image.id }
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:notice]).to eq("Image was successfully updated")
    end
    it "response renders edit if fail" do
      put :update, { id: image.id, image: { image: nil } }
      expect(response).to be_successful
      expect(response).to render_template "edit"
    end

    it "has assign" do
      put :update, { id: image.id, image: { image: file_uploaded } }
      expect(assigns(:img)).to eq(image)
    end

    it "changes image" do
      expect {
        put :update, { id: image.id, image: { image: file_uploaded } }
      }.to change{ image.reload.image_file_size }.to(62858)
    end

    it "changes tags of image" do
      tid = []
      tid << FactoryGirl.create(:orphan_tag).id.to_s
      tid << FactoryGirl.create(:orphan_tag).id.to_s
      expect {
        put :update, id: image.id, image: { tag_ids: tid }
      }.to change { image.reload.tags.count }.to(2)
    end

    it "redirects on index if tag not found" do
      put :update, { id: 0 }
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:alert]).to eq("Can't find such Image.")
    end
  end

  describe 'DELETE "destroy"' do
    let(:tagging) { FactoryGirl.create(:images_tag) }
    let!(:image) { tagging.image }

    it "response redirects" do
      delete :destroy, { id: image.id }
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:notice]).to eq("Image deleted successfully.")
    end

    it "has assign" do
      delete :destroy, { id: image.id }
      expect(assigns(:img)).to eq(image)
    end

    it "deletes tag" do
      expect {
        delete :destroy, { id: image.id }
      }.to change(Image, :count).by(-1)
    end

    it "deletes taggings" do
      count = image.images_tags.size
      expect {
        delete :destroy, { id: image.id }
      }.to change(ImagesTag, :count).by(-count)
    end

    it "redirects on index if tag not found" do
      delete :destroy, { id: 0 }
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:alert]).to eq("Can't find such Image.")
    end
  end

end
