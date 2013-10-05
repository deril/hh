require 'spec_helper'

describe DispatchTagsController do

  let!(:tag1) { FactoryGirl.create(:tag, name: "A_first") }
  let!(:tag2) { FactoryGirl.create(:tag, name: "Z_last") }

  describe "#index" do
    it "finds group of tags" do
      get :index 
      assigns(:tags).should == [tag1, tag2]
    end
    it "success" do
      get :index 
      response.should be_success
    end
  end

  describe "#new" do
    # it "builds new tag" do
    #   get :new
    #   assigns(:tag).should == # new obj
    # end
    it "success" do
      get :new 
      response.should be_success
    end
  end

end
