require 'spec_helper'

describe Group do
  
  it { should have_many(:tags) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

end
