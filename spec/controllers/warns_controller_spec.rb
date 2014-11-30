require 'rails_helper'

describe WarnsController, :type => :controller do

  describe "#show" do
    let(:tag) { FactoryGirl.create(:tag) }
    let(:image) { FactoryGirl.create(:image, tags: [tag]) }
    let(:warn) { FactoryGirl.create(:warn, images: [image]) }

    context 'if not found' do
      it "redirects on root" do
        get :show, { id: 0 }
        expect(response).to be_redirect
      end
      it 'redirects with alert' do
        get :show, { id: 0 }
        expect(flash[:alert]).to eq('Warn not found')
      end
    end
    it "responds success" do
      get :show, { id: warn.id }
      expect(response).to be_success
    end
    it "has warn, images and tags variables" do
      get :show, { id: warn.id }
      expect(assigns(:cur_warn)).to eq(warn)
      expect(assigns(:imgs)).to eq([image])
      expect(assigns(:tags)).to eq([tag])
    end
  end

end
