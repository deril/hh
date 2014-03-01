require 'spec_helper'

describe Dispatch::ImgsController do

  let!(:admin) { FactoryGirl.create(:admin) }  
  let!(:tagging) { FactoryGirl.create(:images_tag) }
  let!(:image) { tagging.image }
  let(:tag) { tagging.tag }
  let!(:warn) { FactoryGirl.create(:warn) }
  let!(:file_fixture) { fixture_file_upload('/images/valid.jpeg', 'image/jpeg') } 

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

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
      assigns(:tags).should == Tag.order("name ASC")
      assigns(:warns).should == Warn.all.load()
    end
  end

  describe 'POST "create"' do
    it "response redirect if all good" do
      post :create, image: { image: file_fixture }
      response.should redirect_to dispatch_imgs_path
      flash[:notice].should == "Image was successfully created"
    end

    it "response renders new if fail" do
      post :create
      response.should render_template "new"
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
    it 'gets good response' do
      get :edit, { id: image.id }
      response.should be_success
    end

    it 'has assigns' do
      get :edit, { id: image.id }
      assigns(:img).should == image
      assigns(:tags).should == Tag.order("name ASC")
      assigns(:warns).should == Warn.all.load()
    end

    it "redirects on index if tag not found" do
      get :edit, { id: 0 }
      response.should redirect_to dispatch_imgs_path
      flash[:alert].should == Image.not_found[:alert]
    end
  end

  describe 'PUT update' do 

    let(:file_uploaded) { fixture_file_upload('/images/uploaded.jpeg', 'image/jpeg') } 

    it "response redirects if all good" do
      put :update, { id: image.id }
      response.should redirect_to dispatch_imgs_path
      flash[:notice].should == "Image was successfully updated"
    end
    it "response renders edit if fail" do
      put :update, { id: image.id, image: { image: nil } }
      response.should be_successful
      response.should render_template "edit"
    end

    it "has assign" do
      put :update, { id: image.id, image: { image: file_uploaded } }
      assigns(:img).should == image
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
      response.should redirect_to dispatch_imgs_path
      flash[:alert].should == Image.not_found[:alert]
    end
  end

  describe 'DELETE "destroy"' do
    it "response redirects" do
      delete :destroy, { id: image.id }
      response.should redirect_to dispatch_imgs_path
      flash[:notice].should == "Image deleted successfully."
    end

    it "has assign" do
      delete :destroy, { id: image.id }
      assigns(:img).should == image
    end

    it "deletes tag" do
      expect {
        delete :destroy, { id: image.id }
      }.to change(Image, :count).by(-1)
    end

    it "deletes taggings" do
      count = image.tags.size
      expect {
        delete :destroy, { id: image.id }
        }.to change(ImagesTag, :count).by(-count)
    end

    it "redirects on index if tag not found" do
      delete :destroy, { id: 0 }
      response.should redirect_to dispatch_imgs_path
      flash[:alert].should == Image.not_found[:alert]
    end
  end

end
