require 'spec_helper'

describe Image do
  
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
  
  it { should accept_nested_attributes_for(:images_tags) }
  it { should accept_nested_attributes_for(:warn) }

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
      image.image_file_name.should == name
    end
  end

  describe '#save_with_response' do 
    it "returns notice if good saving" do
      result = FactoryGirl.build(:image).save_with_response
      result.should == { notice: "Image saved successfully." }
    end
    it "returns alert if bad saving" do
      result = FactoryGirl.build(:image, image: nil).save_with_response
      result.should == { alert: "Image saving failed." }
    end
  end

  describe '#destroy_with_response' do 
    it "returns notice if good destroying" do
      result = image.destroy_with_response
      result.should == { notice: "Image deleted successfully." }
    end
    it "returns alert if bad destroying" do
      image.expects(:destroy).returns(false)
      result = image.destroy_with_response
      result.should == { alert: "Image deleting failed." } 
    end
  end

  describe "#get_dimensions" do
    it 'returns images sizes' do
      sizes = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(image.image))
      image.get_dimensions.to_s.should == sizes.to_s 
    end
  end

  describe "#get_adapted_size" do
    it "shows Kb's" do
      image.get_adapted_size.should == "156 Kb" 
    end

    it "shows Mb's" do
      image.image_file_size = 52428800
      image.save!
      image.get_adapted_size.should == "50 Mb" 
    end
  end

end
