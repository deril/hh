require 'rails_helper'

describe Tag do

  it { should have_many(:images_tags).dependent(:destroy) }
  it { should have_many(:images).through(:images_tags) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  let!(:tag) { FactoryGirl.build(:tag) }

  describe "tag with speces" do
    it "saves all in downcase, stripped and with underscores" do
      tag.name = ' some_tag Name '
      tag.save
      expect(tag.reload.name).to eq('Some tag name')
    end
  end

  describe '.prepare_name' do
    it 'make name in appropriate format' do
      name = ' some_tag Name '
      expect(Tag.prepare_name(name)).to eq('Some tag name')
    end
  end

  describe '#prepare_name' do
    it 'make name of tag in appropriate format' do
      tag.name = ' some_tag Name '
      expect(tag.prepare_name()).to eq('Some tag name')
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
      expect(tag).to receive(:destroy).and_return(false)
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
