require 'spec_helper'

describe Group do
  
  it { should have_many(:tags) }
  it { should have_many(:children).class_name("Group").with_foreign_key("group_id") }
  it { should belong_to(:parent).class_name("Group").with_foreign_key("group_id") }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

end
