require 'rails_helper'

RSpec.describe 'Wallet API', type: :request do
  # initialize test data
  let!(:wallets) { create_list(:wallet, 10) }
  let(:wallet_id) { wallets.first.id }

  # Test suite for GET /todos
  describe 'GET /api/wallets' do
    # make HTTP get request before each example
    before { get '/api/wallets' }

    it 'returns wallets' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end