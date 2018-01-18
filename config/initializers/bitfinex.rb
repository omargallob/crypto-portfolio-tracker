Bitfinex::Client.configure do |conf|
  # add `secret` and `api_key` if you need to access authenticated endpoints.  
  conf.secret = ENV['BFX_API_SECRET']
  conf.api_key = ENV['BFX_API_KEY']
  
end