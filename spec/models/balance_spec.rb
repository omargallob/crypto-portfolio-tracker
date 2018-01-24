require 'rails_helper'
# Test suite for the Todo model
RSpec.describe Balance, type: :model do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should belong_to(:wallet) }

  it { should have_many(:txes) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  
end