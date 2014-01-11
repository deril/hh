require "spec_helper"

describe ApplicationHelper, type: :helper do
  describe "#tag_cloud" do
    let(:classes) { %w[s m l] }
    let(:tag) { FactoryGirl.create(:tag, :count => 6) }
    let(:tag2) { FactoryGirl.create(:tag, :count => 3) }
    let(:tag3) { FactoryGirl.create(:tag, :count => 1) }
    let(:tags) { [tag, tag2, tag3] }
    it "creates valid css class" do
      expect { |b| helper.tag_cloud(tags, classes, &b) }.to yield_successive_args([tag, "l"], [tag2, "m"], [tag3, "s"])
    end
  end
end
