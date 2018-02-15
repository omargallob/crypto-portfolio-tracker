require 'rails_helper'
# Test suite for the Todo model
RSpec.describe TradingPair, type: :model do

  it { should belong_to(:balance) }

  it { should have_many(:trades) }

end