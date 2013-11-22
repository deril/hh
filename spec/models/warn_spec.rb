require 'spec_helper'

describe Warn do

  it { have_many(:images) }
  it { should validate_presence_of(:name) } 

end