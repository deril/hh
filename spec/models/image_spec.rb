require 'spec_helper'

describe Image do
  
  let(:image) { FactoryGirl.create(:image) }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).in(0.5..50.megabytes) }
  it { should validate_attachment_content_type(:image).allowing('image/jpeg')
                                                      .allowing('image/png')
                                                      .allowing('image/gif') }
  it { should have_and_belong_to_many(:tags) }

  describe '"#rename_image!" method' do
    it 'renames name of attached file' do
      expect {
        image.rename_image!
        image.save
      }.to change{ image.reload.image_file_name }.to('HH_' + image.image_updated_at.to_i.to_s + '.jpeg')
    end
  end

  describe "after filter" do
    describe "increment_count" do
      it 'add +1 to count column of all images tags' do
        new_img = FactoryGirl.build(:image)
        expect {
          new_img.save!
        }.to change(new_img.tags, :count).by(1)
      end
    end

    describe "decrement_count" do
      it "decrements 1 from count column of all images tags" do
        tags = image.tags
        expect {
          image.destroy
        }.to change(tags, :count).by(-1)
      end
    end
  end

  # describe 'before filter' do
  #   it 'decrements count column all previous tags and increment in all new tags' do
  #     tags = image.tags
  #     new_tags = [ FactoryGirl.create(:tag) ] 
  #     expect {
  #       image.update_attributes!(tags: new_tags)
  #     }.to change(tags, :count).by(-1)
  #     # expect {
  #     #   image.update_attributes!(tags: new_tags)
  #     # }.to change(new_tags, :count).by(1)
  #   end
  # end

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

end