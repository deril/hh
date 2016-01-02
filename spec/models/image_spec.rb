require 'rails_helper'

describe Image, type: :model do

  let(:image) { FactoryGirl.create(:image) }
  let(:tag) { FactoryGirl.create(:tag) }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).in(0.5..50.megabytes) }
  it { should validate_attachment_content_type(:image).allowing('image/jpeg')
                                                      .allowing('image/png')
                                                      .allowing('image/gif') }

  it { should have_many(:tags).through(:images_tags) }
  it { should have_many(:images_tags).dependent(:destroy) }
  it { should belong_to(:warn) }
  it { should respond_to(:alt) }

  it { should accept_nested_attributes_for(:tags) }

  before(:all) do
    Timecop.freeze(Time.now)
  end

  after(:all) do
    Timecop.return
  end

  describe '"#rename_image!"' do
    it 'renames name of attached file' do
      name = 'hentaria_' + Time.now.to_i.to_s + '.jpeg'
      image.rename_image!
      expect(image.image_file_name).to eq(name)
    end
  end

  describe '#save_with_response' do
    it "returns notice if good saving" do
      result = FactoryGirl.build(:image).save_with_response
      expect(result).to eq({ notice: "Image saved successfully." })
    end
    it "returns alert if bad saving" do
      result = FactoryGirl.build(:image, image: nil).save_with_response
      expect(result).to eq({ alert: "Image saving failed." })
    end
  end

  describe '#destroy_with_response' do
    it "returns notice if good destroying" do
      result = image.destroy_with_response
      expect(result).to eq({ notice: "Image deleted successfully." })
    end
    it "returns alert if bad destroying" do
      expect(image).to receive(:destroy).and_return(false)
      result = image.destroy_with_response
      expect(result).to eq({ alert: "Image deleting failed." })
    end
  end

  describe "#get_dimensions" do
    it 'returns images sizes' do
      sizes = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image.image))
      expect(image.get_dimensions.to_s).to eq(sizes.to_s)
    end
  end

  describe "#get_adapted_size" do
    it "shows Kb's" do
      expect(image.get_adapted_size).to eq("156 Kb")
    end

    it "shows Mb's" do
      image.image_file_size = 52428800
      image.save!
      expect(image.get_adapted_size).to eq("50 Mb")
    end
  end

  describe "#make_hash!" do
    it 'fill up image_hash if it is not filled' do
      expect(image.image_hash).to eq(nil)
      image.make_hash!
      expect(image.image_hash).to_not eq(nil)
    end
    it 'returns false if image_hash already filled' do
      image.update_column(:image_hash, 'test_hash')
      expect(image.image_hash).to eq('test_hash')
    end
  end

  describe '#add_alt' do
    context 'with tags' do
      it 'fills in alt field' do
        image = FactoryGirl.create(:image_with_tags)
        expect(image.alt).to eq(image.tags.unscoped.order(count: :desc).limit(6).map(&:name).join(', '))
      end
    end
    context 'without tags' do
      it 'returns empty string' do
        image = FactoryGirl.create(:image)
        expect(image.alt).to eq ''
      end
    end
  end

end
