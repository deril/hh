require 'spec_helper'

describe Tag do
  
  it { should have_and_belong_to_many(:images) }
  it { should belong_to(:group) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

end
