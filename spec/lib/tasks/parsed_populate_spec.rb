require 'rails_helper'
require 'rake'
Rails.application.load_tasks

describe 'Rake task parsed:populate' do
  let(:valid_yml) { Rails.root() + 'spec/fixtures/ymls/valid.yml' }
  let(:invalid_yml) { Rails.root() + 'spec/fixtures/ymls/invalid.yml' }
  let!(:warn) { FactoryGirl.create(:warn, name: 'virgin') }

  before do
    reset_constant(YAMLParser, :DATA_PATH, (Rails.root + 'spec/fixtures/images'))
    reset_constant(YAMLParser, :CONTENT_FILE, valid_yml)
  end

  it "calls YAMLParser if all good" do
    expect_any_instance_of(YAMLParser).to receive(:call)
    Rake::Task["parsed:populate"].invoke
  end
  context 'does not call YAMLParser if' do
    it 'content dir is empty' do
      allow(Dir).to receive(:empty?).and_return(true)
      expect_any_instance_of(YAMLParser).to_not receive(:call)
      Rake::Task["parsed:populate"].invoke
    end
    it 'content dir does not exist' do
      allow(Dir).to receive(:exists?).and_return(false)
      expect_any_instance_of(YAMLParser).to_not receive(:call)
      Rake::Task["parsed:populate"].invoke
    end
  end

private
  def reset_constant(klass, const_name, const_val)
    klass.instance_eval do
      remove_const(const_name)
      const_set(const_name, const_val)
    end
  end
end
