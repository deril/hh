require 'rails_helper'

describe Dispatch::StackController, type: :controller do
  before :each do
    admin = FactoryGirl.create(:admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in admin
  end

  def reset_stack_const(const_name, value)
    if Dispatch::StackController.const_defined?(const_name)
      Dispatch::StackController.send(:remove_const, const_name)
      Dispatch::StackController.const_set(const_name, value)
    end
  end

  describe 'GET "index"' do
    let!(:tag) { FactoryGirl.create(:orphan_tag) }
    let!(:warn) { FactoryGirl.create(:warn) }

    before :each do
      reset_stack_const(:IMG_LAST_DIR, 'images')
      stack_path = Rails.root.join("spec", "fixtures", "#{Dispatch::StackController::IMG_LAST_DIR}")
      reset_stack_const(:IMG_TMP_DIR, stack_path)
    end

    it "redirects if dir not found" do
      reset_stack_const(:IMG_TMP_DIR, Rails.root.join("fake_path"))
      get :index
      expect(response).to redirect_to dispatch_imgs_path
      expect(flash[:alert]).to eq("Dir not found")
    end
    it "has good response if all good" do
      get :index
      expect(response).to be_success
    end
    it "gets assigns" do
      get :index
      expect(assigns(:img_f)).to eq("#{Dispatch::StackController::IMG_LAST_DIR}/similar_valid.jpeg")
      expect(assigns(:tags)).to eq(Tag.order("name ASC"))
      expect(assigns(:warns)).to eq(Warn.all.load())
    end
  end

  describe 'POST "create"' do
    let(:tag) { FactoryGirl.create(:orphan_tag) }

    before(:all) do
      reset_stack_const(:IMG_LAST_DIR, 'images')
      stack_path = Rails.root.join("spec", "fixtures", "#{Dispatch::StackController::IMG_LAST_DIR}")
      reset_stack_const(:IMG_TMP_DIR, stack_path)
    end

    before { expect(File).to receive(:delete).and_return(true) }

    it "response redirects" do
      post :create
      expect(response).to redirect_to dispatch_stack_index_path
    end
    context "if image accepted" do
      it "creates new image row" do
        expect {
          post :create, { image: { image: "valid.jpeg" }, button: "accept" }
        }.to change(Image, :count).by(1)
      end
      it "gets good response" do
        post :create, { image: { image: "valid.jpeg" }, button: "accept" }
        expect(flash[:notice]).to eq("Image saved successfully.")
      end
      it "adds images_tags" do
        tids = [tag.id.to_s]
        expect {
          post :create, { image: { image: "valid.jpeg", tag_ids: tids }, button: "accept" }
        }.to change(ImagesTag, :count).by(1)
      end
    end
    context "if image not accepted" do
      it "does not create new image row" do
        expect {
          post :create, { image: { image: "valid.jpeg" }, button: "deny" }
        }.to change(Image, :count).by(0)
      end
    end
  end

  describe "#check_img?" do
    let(:valid_file_path) { Rails.root.to_s + '/spec/fixtures/images/valid.jpeg' }
    let(:invalid_file_path) { Rails.root.to_s + '/spec/fixtures/images/invalid.jpg' }
    let(:stack) { Dispatch::StackController.new }

    it "gets false if ext_name not of image" do
      expect(stack.send(:check_img?, "invalid.rb")).to eq(false)
    end
    it "gets false if header of file not of image" do
      expect(stack.send(:check_img?, invalid_file_path)).to eq(false)
    end
    it "gets true if it is a image" do
      expect(stack.send(:check_img?, valid_file_path)).to eq(true)
    end
  end

end
