require 'spec_helper'

describe Tag do
  
  it { should have_many(:images_tags).dependent(:destroy) }
  it { should have_many(:images).through(:images_tags) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  let!(:tag) { FactoryGirl.build(:tag) }

  describe "tag with speces" do
    let(:bad_name) { " some_New  Action " }
    it "saves all in downcase, stripped and with underscores" do
      tag.name = bad_name
      tag.save
      expect(tag.reload.name).to eq bad_name.strip.downcase.gsub(/\s+|_+/, ' ').capitalize
    end
  end

  describe "#save_with_response" do
    it "gets message if saving fail" do
      tag.name = nil
      tag.save_with_response.should == { alert: "Something bad with tag Saving." } 
    end
    it "gets message if saving ok" do
      tag.save_with_response.should == { notice: "Tag successfully Saved." }
    end
  end

  describe "#destroy_with_response" do
    it "gets message if destroying fail" do
      tag.stubs(:destroy).returns(false)
      tag.destroy_with_response.should == { alert: "Something bad with tag Deleting." }
    end
    it "gets message if destroying ok" do
      tag.destroy_with_response.should == { notice: "Tag successfully Deleted." }
    end
  end

  describe "#not_found" do
    it { Tag.not_found.should == { alert: "Can't find such Tag." } }
  end

end
