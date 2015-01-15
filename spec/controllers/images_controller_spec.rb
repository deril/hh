require 'rails_helper'

describe ImagesController, type: :controller do

  describe "#index" do
    let(:tag_1) { FactoryGirl.create(:tag) }
    let!(:image) { FactoryGirl.create(:image, tags: [tag_1]) }

    it "has success response" do
      get :index
      expect(response).to be_success
    end
    it "has imgs and tags variables" do
      get :index
      expect(assigns(:imgs)).to eq([image])
      expect(assigns(:tags).sort).to eq([tag_1])
    end
  end

  describe "#show" do
    let(:tag_1) { FactoryGirl.create(:tag) }
    let(:image) { FactoryGirl.create(:image, tags: [tag_1]) }

    context "if tag not found" do
      it "has response redirect" do
        get :show, { id: 0 }
        expect(response).to be_redirect
      end
      it 'redirects with alert' do
        get :show, { id: 0 }
        expect(flash[:alert]).to eq("Can't find such Image.")
      end
    end
    it "has success response" do
      get :show, { id: image.id }
      expect(response).to be_success
    end
    it "has img and tags variables" do
      get :show, { id: image.id }
      expect(assigns(:img)).to eq(image)
      expect(assigns(:tags)).to eq([tag_1])
    end
    it 'has also_images variable' do
      get :show, { id: image.id }
      expect(assigns(:also_images).to_a).to be_kind_of(Array)
      expect(assigns(:also_images).first).to be_kind_of(Image)
    end
  end

  describe '#random' do
    it "has redirect response" do
      get :random
      expect(response).to be_redirect
    end
    it 'has no image defined if on images at all' do
      get :random
      expect(subject).to redirect_to(image_path(0))
    end
    it 'has random image defined if all good' do
      image = FactoryGirl.create(:image)
      get :random
      expect(subject).to redirect_to(image_path(image.id))
    end
  end
end
