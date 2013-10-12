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

  describe 'GET "edit"' do
    it 'gets good response' do
      get :edit, { id: image.id }
      response.should be_success
    end

    it 'has assigns' do
      get :edit, { id: image.id }
      assigns(:img).should == image
      assigns(:tags).should == [tag]
    end
  end

  describe 'PUT update' do 
    it "response redirects if all good" do
      put :update, { id: image.id }#, image: { image_file_size: 10 } }
      response.should redirect_to dispatch_imgs_path
      flash[:notice].should == "Image saved successfully."
    end
    it "response redirects if all good" do
      put :update, { id: image.id, image: { image: nil } }
      response.should redirect_to dispatch_imgs_path
      flash[:alert].should == "Image saving failed."
    end

    xit "has assign" do
      put :update, { id: image.id, image: { image_file_size: 10 } }
      assigns(:image).should == image
    end

    xit "changes image" do 
      expect {
        put :update, { id: image.id, image: { image_file_size: 10 } }
      }.to change{ image.image_file_size }.to(10)
    end

    xit "changes tags of image"
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
  end

end
