require 'rails_helper'
# Test suite for the Todo model
RSpec.describe Wallet, type: :model do

  before(:all) do
    @exchange = user = create(:exchange)
    @wallet = @exchange.wallets.create(name: 'btc')
  end

  it { should belong_to(:exchange) }

  it { should have_one(:balance) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }

end
