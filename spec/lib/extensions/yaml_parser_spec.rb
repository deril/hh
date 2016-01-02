require 'rails_helper'

describe "YAMLParser" do
  let(:parser) { YAMLParser.new() }


  describe '#call' do
    let(:valid_yml) { Rails.root() + 'spec/fixtures/ymls/valid.yml' }
    let(:invalid_yml) { Rails.root() + 'spec/fixtures/ymls/invalid.yml' }

    before do
      reset_constant(:DATA_PATH, (Rails.root + 'spec/fixtures/images'))
      reset_constant(:CONTENT_FILE, valid_yml)
    end

    let!(:warn) { FactoryGirl.create(:warn, name: 'virgin') }

    it 'create new image' do
      expect { parser.call }.to change(Image, :count).by(1)
    end
    it 'adds image' do
      parser.call
      expect(Image.last.image.present?).to eq(true)
    end
    it 'adds tags' do
      parser.call
      expect(Image.last.tags.size).to eq(2)
    end
    it 'adds warn' do
      parser.call
      expect(Image.last.warn).to eq(warn)
    end
    it 'raises error if something goes wrong' do
      reset_constant(:CONTENT_FILE, invalid_yml)
      expect { parser.call }.to raise_error(Psych::SyntaxError)
    end
  end

  describe 'private method' do
    describe '#load_yaml_file' do
      let(:valid_yml) { Rails.root() + 'spec/fixtures/ymls/valid.yml' }
      let(:invalid_yml) { Rails.root() + 'spec/fixtures/ymls/invalid.yml' }

      it 'returns array of data if yaml file valid' do
        reset_constant(:CONTENT_FILE, valid_yml)
        etalon = YAML.load_file(valid_yml)
        expect(parser.send(:load_yaml_file)).to eq(etalon)
      end
      it 'raises error if yaml file invalid' do
        reset_constant(:CONTENT_FILE, invalid_yml)
        expect{ parser.send(:load_yaml_file) }.to raise_error(Psych::SyntaxError)
      end
    end

    describe '#add_image_file' do
      let(:image) { Image.new() }

      it 'adds image' do
        reset_constant(:DATA_PATH, (Rails.root + 'spec/fixtures/images'))
        expect {
          parser.send(:add_image_file, image, 'valid.jpeg')
        }.to change(image, :image_file_name).to('valid.jpeg')
      end
      it 'raises error if file invalid' do
        expect {
          parser.send(:add_image_file, image, 'invalid.jpeg')
        }.to raise_error(Errno::ENOENT)
      end
      it 'raises error if no file' do
        expect {
          parser.send(:add_image_file, image, 'notfoundfile.jpg')
        }.to raise_error(Errno::ENOENT)
      end
    end

    describe "#add_tags" do
      let(:image) { Image.new() }

      it 'creates new tag if it not found' do
        expect {
          parser.send(:add_tags, image, 'tag_1 tag_2')
        }.to change(Tag, :count).by(2)
      end
      it 'adds new tags' do
        expect {
          parser.send(:add_tags, image, 'tag_1 tag_2')
        }.to change{ image.tags.map(&:name).sort }.by(['Tag 1', 'Tag 2'])
      end
      it 'adds found tags' do
        parser.send(:add_tags, image, 'tag_1 tag_2')
        expect {
          parser.send(:add_tags, image, 'tag_1 tag_2')
        }.to_not change{ image.tags.map(&:name).sort }
      end
    end

    describe '#add_warn' do
      let(:image) { Image.new() }

      it 'adds warn' do
        warn = FactoryGirl.create(:warn)
        expect {
          parser.send(:add_warn, image, warn.name)
        }.to change{ image.warn }.to(warn)
      end
      it 'raises error if warn not found' do
        expect {
          parser.send(:add_warn, image, nil)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe '#add_content' do
      let(:warn) { FactoryGirl.create(:warn) }
      let(:image) { Image.new() }
      let(:sample) { { image: 'valid.jpeg', tags: 'tag_1', warn: warn.name } }

      it 'adds image' do
        expect {
          parser.send(:add_content, image, sample)
        }.to change{ image.image.present? }.to(true)
      end
      it 'adds tags' do
        expect {
          parser.send(:add_content, image, sample)
        }.to change{ image.tags.size }.by(1)
      end
      it 'adds warn' do
        expect {
          parser.send(:add_content, image, sample)
        }.to change{ image.warn }.to(warn)
      end
      it 'raises error if something goes wrong' do
        expect {
          parser.send(:add_content, image, {})
        }.to raise_error(TypeError)
      end
    end

    describe '#prepare' do
      it 'returns formated string' do
        str = '%&^() me'
        expect(parser.send(:prepare, str)).to eq('me')
      end
    end

    describe '#make_array' do
      it 'returns appropriate array' do
        str = '   asd s  s sadddddddddddddddddddddddddddddddddddddddddddddddddd'
        expect(parser.send(:make_array, str)).to eq(['asd','s'])
      end
    end
  end

private
  def reset_constant(const_name, const_val)
    parser.class.instance_eval do
      remove_const(const_name)
      const_set(const_name, const_val)
    end
  end

end
