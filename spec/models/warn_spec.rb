require 'rails_helper'

describe Warn, type: :model do

  it { have_many(:images) }
  it { should validate_presence_of(:name) }

  describe '#to_param' do
    let(:warn) { FactoryGirl.create(:warn) }

    it 'returns id & name' do
      etalon = "#{warn.id}-#{warn.name}"
      expect(warn.to_param).to eq(etalon)
    end
  end

end
