module CryptoCompare
  class CoinResponse
    attr_reader :http_response

    DEFAULT_ERROR_MESSAGE = 'There was an error retrieving product details.'.freeze

    def initialize(http_response)
      @http_response = http_response
    end

    def success?
      http_response.status == 200
    end

    def error_message
      data.fetch('message', DEFAULT_ERROR_MESSAGE)
    end

    def values
      data
    end

    private

    def data
      http_response.parse(:json)
    end
  end
end
