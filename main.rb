require 'net/http'
require 'json'
require 'irb'

class Summoner
  attr_accessor :name, :tier, :dision, :league_points

  def initialize(options)
    @name = options[:name]
    @tier = get_tier_level(options[:tier])
    @division = get_rank_level(options[:division])
    @league_points = options[:lp]
  end
end


KEY = "YOUR_KEY_HERE"

def create_request(request)
  URI("https://na1.api.riotgames.com/#{request}?api_key=#{KEY}")
end

def get(uri)
  Net::HTTP.get(uri)
end

def get_tier_level(tier)
  [
    'BRONZE',
    'SILVER',
    'GOLD',
    'PLATINUM',
    'DIAMOND',
    'MASTER',
    'CHALLENGER'
  ].index(tier.upcase)
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

def get_summoner_rank(summonerId)
  league_rank = JSON.parse(get(create_request("lol/league/v3/positions/by-summoner/#{summonerId}")))
    .select { |x| x['queueType'] == 'RANKED_SOLO_5x5' }
    .first

  Summoner.new(
    name: league_rank['playerOrTeamName'],
    tier: league_rank['tier'],
    division: league_rank['rank'],
    lp: league_rank['leaguePoints']
  )
end
