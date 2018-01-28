require 'rails_helper'
# Test suite for the Todo model
RSpec.describe Balance, type: :model do
  
  it { should belong_to(:wallet) }

  it { should have_many(:txes) }
  
  it { should have_many(:trading_pairs) }
end