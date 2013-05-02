require 'spec_helper'

describe Image do
  
  let(:image) { FactoryGirl.create(:image) }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_size(:image).in(0.5..30.megabytes) }
  it { should validate_attachment_content_type(:image).allowing('image/jpeg')
                                                      .allowing('image/png')
                                                      .allowing('image/gif') }

  describe '"#rename_image!" method' do
    it 'renames name of attached file' do
      expect {
        image.rename_image!
        image.save
      }.to change{ image.reload.image_file_name }.to('HH_' + image.image_updated_at.to_i.to_s + '.jpeg')
    end
  end

  # describe '"#save_with_response" method' do 
  #   it "returns notice if good saving" do
  #     rezult = FactoryGirl.build(:image).save_with_response
  #     rezult.should == { notice: "Image saved successfully." }
  #   end
  #   it "returns alert if bad saving" do
  #     rezult = FactoryGirl.build(:image, image: nil).save_with_response
  #     rezult.should == { alert: "Image saving failed." }
  #   end
  # end

end