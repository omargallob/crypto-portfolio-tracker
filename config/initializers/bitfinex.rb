Bitfinex::Client.configure do |conf|
  # add `secret` and `api_key` if you need to access authenticated endpoints.
  conf.secret = ENV["BFX_API_SECRET"]
  conf.api_key = ENV["BFX_API_KEY"]

  # uncomment if you want to use version 2 of the API
  # which is opt-in at the moment
  #
  # conf.use_api_v2
end