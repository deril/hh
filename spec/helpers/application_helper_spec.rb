require 'rails_helper'

describe ApplicationHelper, type: :helper do

  let(:tag1) { FactoryGirl.create(:tag, count: 6) }
  let(:tag2) { FactoryGirl.create(:tag, count: 3) }
  let(:tag3) { FactoryGirl.create(:tag, count: 1) }
  let(:tags) { [tag3, tag2, tag1] }


  describe "#tag_cloud" do
    let(:classes) { %w[s m l] }

    it "creates valid css class" do
      expect { |b|
        helper.tag_cloud(tags, classes, &b)
      }.to yield_successive_args([tag3, "s"], [tag2, "m"], [tag1, "l"])
    end
    it "returns empty array if no tags" do
      tags = []
      expect(helper.tag_cloud(tags, classes)).to eq([])
    end
  end

  describe "#alert_notifier" do
    it 'has wrapping class' do
      expect(helper.alert_notifier).to match(/class=\"clear-legacy\"/)
    end
    it 'has notice message if it present' do
      flash[:notice] = 'notice test'
      expect(helper.alert_notifier).to match(/notice test/)
      expect(helper.alert_notifier).to match(/class=\"notice\"/)
    end
    it 'has alert message if it present' do
      flash[:alert] = 'alert test'
      expect(helper.alert_notifier).to match(/alert test/)
      expect(helper.alert_notifier).to match(/class=\"alert\"/)
    end
    it 'has and notice message and alert message if they present' do
      flash[:notice] = 'notice test'
      flash[:alert] = 'alert test'
      expect(helper.alert_notifier).to match(/notice test/)
      expect(helper.alert_notifier).to match(/alert test/)
    end
  end

  describe '#sort_only_by' do
    it 'sorts array of objects by current field' do
      expect(helper.sort_only_by(tags, :count)).to eq([tag3, tag2, tag1])
    end
    it 'fails if current field does not exist' do
      expect { helper.sort_only_by(tags, :invalid) }.to raise_error
    end
    it 'returns what we pulled in if it\'s not array' do
      expect(helper.sort_only_by('', :count)).to eq('')
    end
  end

  describe '#join_by' do
    it 'returns string of joined current field meanings' do
      result = tag3.count.to_s + ', ' + tag2.count.to_s + ', ' + tag1.count.to_s
      expect(helper.join_by(tags, :count)).to eq(result)
    end
    it 'returns string of only current amount objects in array if amount var defined' do
      result = tag3.count.to_s + ', ' + tag2.count.to_s
      expect(helper.join_by(tags, :count, 2)).to eq(result)
    end
    it 'fails if current field does not exist' do
      expect { helper.join_by(tags, :invalid) }.to raise_error
    end
    it "returns empty string if give inside not array" do
      expect(helper.join_by('', :count)).to eq('')
    end
  end
end
