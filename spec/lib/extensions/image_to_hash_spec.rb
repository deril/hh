require 'rails_helper'

describe ImageToHash::HashMaker do

  describe "#make_hash" do
    let(:img_path) { Rails.root() + 'spec/fixtures/images/valid.jpeg' }
    let(:invalid_img_path) { Rails.root() + 'spec/fixtures/images/invalid.jpg' }

    it "has success response" do
      expect { ImageToHash::HashMaker.make_hash(img_path) }.to_not raise_error
    end
    it "returns false if image not found" do
      expect(ImageToHash::HashMaker.make_hash('')).to eq(nil)
    end
    it "returns false if image is invalid" do
      expect(ImageToHash::HashMaker.make_hash(invalid_img_path)).to eq(nil)
    end
    it 'returns hash_code if image was found' do
      result = ImageToHash::HashMaker.make_hash(img_path)
      expect(result).to be_an_instance_of(String)
      expect(result.size).to eq(1024)
    end
  end

  describe "#compare_hashes" do
    let(:has_one) { ImageToHash::HashMaker.make_hash(Rails.root() + 'spec/fixtures/images/valid.jpeg') }
    let(:has_two) { ImageToHash::HashMaker.make_hash(Rails.root() + 'spec/fixtures/images/similar_valid.jpeg') }
    let(:has_other) { ImageToHash::HashMaker.make_hash(Rails.root() + 'spec/fixtures/images/uploaded.jpeg') }

    it "has success response" do
      expect { ImageToHash::HashMaker.compare_hashes('','') }.to_not raise_error
    end
    it 'return nil if one of arguments blank' do
      expect(ImageToHash::HashMaker.compare_hashes('','a')).to eq(nil)
    end
    it "has big persent score if images are not similar" do
      expect(ImageToHash::HashMaker.compare_hashes(has_one, has_other) > 50).to eq(true)
    end
    it 'has small persent score if images are similar' do
      expect(ImageToHash::HashMaker.compare_hashes(has_one, has_two) < 20).to eq(true)
    end
    it 'has a little score if images are same' do
      expect(ImageToHash::HashMaker.compare_hashes(has_one, has_one)).to eq(0)
    end
  end

end
