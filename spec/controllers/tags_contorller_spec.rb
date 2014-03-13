require 'spec_helper'

describe TagsController do

  let!(:custom_tag) { FactoryGirl.create(:tag, name: 'A_name') }
  let(:tag) { FactoryGirl.create(:tag, name: "current_name") }
  let!(:image) { FactoryGirl.create(:image, tags: [custom_tag, tag]) }

  describe "#index" do
    it "has respond success and has tags variable" do
      get :index
      assigns(:tags).should =~ [custom_tag, tag]
      response.should be_success
    end
  end

  describe "#show" do
    it "has response redirect" do
      get :show, { id: 0 }
      response.should redirect_to(tags_path)
      flash[:alert].should == Tag.not_found[:alert]
    end
    it "has respond success" do
      get :show, { id: tag.id }
      response.should be_success
    end 
    it "has cur_tag and images variable" do
      get :show, { id: tag.id }
      assigns(:cur_tag).should == tag
      assigns(:imgs).should == [image]
    end
    it "has tags variable, what has no cur_tag, but all others of images" do
      get :show, { id: tag.id }
      assigns(:tags).should == [custom_tag]
    end
    it "has no tags variable at all, if cur_tag.images is empty" do
      get :show, { id: tag.id }
      assigns(:tags).include?(tag).should == false
    end 
  end

  describe "#autocomplete_search" do
    it "has response success" do
      get :autocomplete_search
      response.should be_success
    end
    it "gets good response if something found" do
      get :autocomplete_search, { term: tag.name[0,3] }
       JSON.parse(response.body).should == ["Current name"]
    end
    it "gets [] if nothing was found" do
      get :autocomplete_search, { term: '' }
      JSON.parse(response.body).should == []
    end
  end

  describe "#search" do
    it "has response success" do
      get :search, { search_query: tag.name + ", some" }
      response.should be_success
    end
    it "has response success" do
      get :search
      response.should redirect_to images_path
    end
    it "has current vars" do
      get :search, { search_query: tag.name + ", some" }
      assigns(:search_tags).should == [tag.name, "some"]
      assigns(:cur_tags).should == [tag]
      assigns(:imgs).should == [image]
      assigns(:tags).sort.should == [custom_tag, tag]
      assigns(:warns).should == Warn.all
    end
  end

end