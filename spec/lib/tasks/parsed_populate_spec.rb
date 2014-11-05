require 'rails_helper'
require 'rake'

load File.join(Rails.root, 'lib', 'tasks', 'parsed_populate.rake')

describe 'Rake task parsed:populate' do
  let(:valid_yml) { Rails.root() + 'spec/fixtures/ymls/valid.yml' }
  let(:invalid_yml) { Rails.root() + 'spec/fixtures/ymls/invalid.yml' }
  let!(:warn) { FactoryGirl.create(:warn, name: 'virgin') }

  before do
    reset_constant(YAMLParser, :DATA_PATH, (Rails.root + 'spec/fixtures/images'))
    reset_constant(YAMLParser, :CONTENT_FILE, valid_yml)
  end

  it 'create new image' do
    expect {
      Rake::Task["parsed:populate"].invoke
    }.to change(Image, :count).by(1)
  end
  it 'adds image' do
    p YAMLParser::CONTENT_FILE
    expect {
      Rake::Task["parsed:populate"].invoke
    }.to change(Image, :count).by(1)
  end
  # it 'adds tags' do
  #   Rake::Task["parsed:populate"].invoke
  #   expect(Image.last.tags.size).to eq(2)
  # end
  # it 'adds warn' do
  #   Rake::Task["parsed:populate"].invoke
  #   expect(Image.last.warn).to eq(warn)
  # end
  # it 'raises error if something goes wrong' do
  #   reset_constant(YAMLParser, :CONTENT_FILE, invalid_yml)
  #   expect {
  #     Rake::Task["parsed:populate"].invoke
  #   }.to raise_error()
  # end
end

private
  def reset_constant(klass, const_name, const_val)
    klass.instance_eval do
      remove_const(const_name)
      const_set(const_name, const_val)
    end
  end
