require 'rails_helper'

describe Group do

  it { should have_many(:tags) }
  it { should have_many(:children).class_name("Group").with_foreign_key("group_id") }
  it { should belong_to(:parent).class_name("Group").with_foreign_key("group_id") }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe "before callback #capitalize_name" do
    let(:group) { FactoryGirl.build(:group, name: "some") }
    it "make name capitalized" do
      expect(group.name).to eq('some')
      group.save!
      expect(group.name).to eq('Some')
    end
  end

end
