require "spec_helper"

class TestImageToHash
  include ImageToHash
end

describe ImageToHash do

  let!(:test_lib) { TestImageToHash.new() }
  let(:img_path) { Rails.root() + 'spec/fixtures/images/valid.jpeg' }
  
  describe "#make_hash" do
    it "has success response" do
      expect { test_lib.make_hash(img_path.to_s) }.to_not raise_error
    end
    it "returns false if image not found"
    it "returns false if image is invalid"
    it 'returns hash_code if image was found'
  end

  describe "#compare_hashes" do
  end

end