require 'net/http'
require 'json'
require 'irb'

require_relative 'summoner'

KEY = 'YOUR_KEY_HERE'.freeze

def create_request(request, params = [])
  params << "api_key=#{KEY}"
  URI("https://na1.api.riotgames.com/#{request}?#{params * '&'}")
end

def get(uri)
  Net::HTTP.get(uri)
end

def get_tier_level(tier)
  %w(
    BRONZE
    SILVER
    GOLD
    PLATINUM
    DIAMOND
    MASTER
    CHALLENGER
  ).index(tier.upcase)
end

def get_rank_level(rank)
  %w(
    I
    II
    III
    IV
    V
  ).index(rank.upcase) + 1
end

def get_summoner(summoner_id)
  league_rank = JSON.parse(get(create_request("lol/league/v3/positions/by-summoner/#{summoner_id}")))
                    .select { |x| x['queueType'] == 'RANKED_SOLO_5x5' }
                    .first

  Summoner.new(
    summoner_id: summoner_id,
    account_id: league_rank['accountId'],
    name: league_rank['playerOrTeamName'],
    tier: league_rank['tier'],
    division: league_rank['rank'],
    lp: league_rank['leaguePoints']
  )
end
