require 'spec_helper'

describe ImagesTag do

  it { should belong_to(:image) }
  it { should belong_to(:tag).counter_cache(:count) }
  it { should accept_nested_attributes_for(:tag) }

end