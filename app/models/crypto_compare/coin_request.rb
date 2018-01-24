module CryptoCompare
  class CoinRequest
    attr_reader :tokens, :values, :connection

    def initialize(path, tokens, values, connection)
      @path = path
      @tokens = tokens
      @values = values
      @connection = connection
    end

    def response
      http_response = connection
        .get(url)
      CoinResponse.new(http_response)
    end

    def url      
      "https://min-api.cryptocompare.com/#{ @path }?fsyms=#{ @tokens.join(",") }&tsyms=#{ @values.join(",") }&extraParams=my-portfolio"
    end
  end
end