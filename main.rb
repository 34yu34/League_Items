require 'net/http'
require 'json'
require 'irb'

KEY = "YOUR_KEY_HERE"

def create_request(request)
  URI("https://na1.api.riotgames.com/#{request}")
end

def get(uri)
  Net::HTTP.get(uri)
end
