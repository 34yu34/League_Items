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

def get_tier_level(tier)
  {
    'BRONZE' => 0,
    'SILVER' => 1,
    'GOLD' => 2,
    'PLATINUM' => 3,
    'DIAMOND' => 4,
    'MASTER' => 5,
    'CHALLENGER' => 6
  }[tier.upcase]
end

def get_rank_level(rank)
  [
    "I",
    "II",
    "III",
    "IV",
    "V",
  ].index(rank.upcase) + 1
end
