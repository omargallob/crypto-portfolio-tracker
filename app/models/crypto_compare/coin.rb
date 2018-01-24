module CryptoCompare
  class Coin
    def initialize
      def initialize(details)
        @details = details
      end
  
      def values
        details.fetch('tags', '').split(' ')
      end
    end
  end
end