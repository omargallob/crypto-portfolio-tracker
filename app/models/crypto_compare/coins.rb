# CryptoCompare::Coins Controller
module CryptoCompare

  require_relative 'coin_request'
  require_relative 'coin_response'
  class Coins
    attr_accessor :key

    def initialize(key)
      @key = key
    end

    def self.fetch(path, coins, values)
      connection = HTTP

      coin_response = CoinRequest.new(path, coins, values, connection).response
      fail CryptoCompareError, coin_response.error_message unless coin_response.success?

      coin_response.values

    end
  end
end