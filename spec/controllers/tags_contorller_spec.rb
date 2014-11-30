require 'rails_helper'

describe TagsController, type: :controller do

  describe "#index" do
    let!(:tag) { FactoryGirl.create(:tag, name: "current_name") }

    it "has respond success" do
      get :index
      expect(response).to be_success
    end
    it 'has tags variable' do
      get :index
      expect(assigns(:tags)).to eq([tag])
    end
  end

  describe "#show" do
    let!(:custom_tag) { FactoryGirl.create(:tag, name: 'A_name') }
    let!(:tag) { FactoryGirl.create(:tag, name: "current_name") }
    let!(:image) { FactoryGirl.create(:image, tags: [custom_tag, tag]) }

    context 'if tag not found' do
      it "has response redirect" do
        get :show, { id: 0 }
        expect(response).to be_redirect
      end
      it 'redirects with alert' do
        get :show, { id: 0 }
        expect(flash[:alert]).to eq("Can't find such Tag.")
      end
    end
    it "has respond success" do
      get :show, { id: tag.id }
      expect(response).to be_success
    end
    it "has cur_tag and images variable" do
      get :show, { id: tag.id }
      expect(assigns(:cur_tag)).to eq(tag)
      expect(assigns(:imgs)).to eq([image])
    end
    it "has tags variable, with all tags of images except current tag" do
      get :show, { id: tag.id }
      expect(assigns(:tags)).to eq([custom_tag])
      expect(assigns(:tags).include?(tag)).to eq(false)
    end
  end

  describe "#autocomplete_search" do
    let(:tag) { FactoryGirl.create(:tag, name: "current_name") }

    it "has response success" do
      get :autocomplete_search
      expect(response).to be_success
    end
    it "gets good response if something found" do
      get :autocomplete_search, { term: tag.name[0,3] }
      expect(JSON.parse(response.body)).to eq(["Current name"])
    end
    it "gets [] if nothing was found" do
      get :autocomplete_search, { term: '' }
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "#search" do
    let!(:custom_tag) { FactoryGirl.create(:tag, name: 'A_name') }
    let(:tag) { FactoryGirl.create(:tag, name: "current_name") }
    let!(:image) { FactoryGirl.create(:image, tags: [custom_tag, tag]) }

    it "has response success" do
      get :search, { search_query: tag.name + ", some" }
      expect(response).to be_success
    end
    it "has response redirect if no search for" do
      get :search
      expect(response).to be_redirect
    end
    it "has current vars" do
      get :search, { search_query: tag.name + ", some" }

      expect(assigns(:search_tags)).to eq([tag.name, "some"])
      expect(assigns(:cur_tags)).to eq([tag])
      expect(assigns(:imgs)).to eq([image])
      expect(assigns(:tags)).to eq([custom_tag, tag])
      expect(assigns(:warns)).to eq(Warn.all)
    end
  end

end
