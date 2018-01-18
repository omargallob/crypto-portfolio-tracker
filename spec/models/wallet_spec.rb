require 'rails_helper'
# Test suite for the Todo model
RSpec.describe Wallet, type: :model do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should belong_to(:exchange) }

  it { should have_one(:balance) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:name) }
end