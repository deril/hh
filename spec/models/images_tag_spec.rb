require 'rails_helper'

describe ImagesTag do

  it { should belong_to(:image) }
  it { should belong_to(:tag).counter_cache(:count) }

end
