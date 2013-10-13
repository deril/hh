require 'spec_helper'

describe DispatchStackController do

  describe "#images_from_dir" do
    before :all do
      DispatchStackController.redefine_const(:IMG_TMP_DIR, 'images')
      DispatchStackController.redefine_const(:IMG_LAST_DIR, Rails.root.join("spec", "fixtures", "#{IMG_LAST_DIR}"))
    end

    it "redirects if dir not found"
    it "has good response if all good"
    it "gets assigns"
  end

  describe "#check_img?" do
    let(:valid_file_path) { Rails.root.to_s + '/spec/fixtures/images/valid.jpeg' } 
    let(:invalid_file_path) { Rails.root.to_s + '/spec/fixtures/images/invalid.jpg' } 
    let(:stack) { DispatchStackController.new }

    it "gets false if ext_name not of image" do
      stack.send(:check_img?, "invalid.rb").should == false
    end
    it "gets false if header of file not of image" do
      stack.send(:check_img?, invalid_file_path).should == false
    end
    it "gets true if it is a image" do
      stack.send(:check_img?, valid_file_path).should == true
    end
  end

end