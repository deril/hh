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

  it { should accept_nested_attributes_for(:images_tags) }

  describe '"#rename_image!"' do

    # FIXME: transiant
    it 'renames name of attached file' do
      image.rename_image!
      image.image_file_name.should == 'HH_' + time.to_i.to_s + '.jpeg'
    end
  end

  describe "before filter" do
    let!(:image_unsaved) { FactoryGirl.build(:image) }

    # FIXME: transiant
    describe "rename_image!" do
      it "change image name" do
        name = 'HH_' + Time.now.to_i.to_s + '.jpeg'
        expect {
          image_unsaved.save!
        }.to change{ image_unsaved.image_file_name }.to(name)
      end
    end
  end

  describe "after filter" do
    describe "increment_count" do
      it 'increments 1 to count column of all images tags' do
        new_img = FactoryGirl.build(:image)
        new_img.tags << tag
        expect {
          new_img.save!
        }.to change(new_img.tags, :count).by(1)
      end
    end

    describe "decrement_count" do
      it "decrements 1 from count column of all images tags" do
        image.tags << tag
        tags = image.tags
        expect {
          image.destroy
        }.to change(tags, :count).by(-1)
      end
    end

    # describe "update_count" do
    #   describe "if tags changed?" do
    #     it "decrements counts of all previous tags" do
    #       expect {
    #         image.update_attributes(tags: [tag])
    #       }.to change(image.tags, :count).by(-1)
    #     end
    #     it "increments counts of all new tags" do
    #       expect {
    #         image.update_attributes(tags: [tag])
    #       }.to change(tag, :count).by(+1)
    #     end
    #   end
    #   describe "if tags not changed?" do
    #     it "nothing happens"
    #   end
    # end
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
