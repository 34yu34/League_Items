require 'net/http'
require 'json'
require 'irb'

class Summoner
  attr_accessor :id, :name, :tier, :dision, :league_points

  def initialize(options)
    @id = options[:id]
    @name = options[:name]
    @tier = get_tier_level(options[:tier])
    @division = get_rank_level(options[:division])
    @league_points = options[:lp]
  end

  def <=>(other)
    if @tier == other.tier
      if @division == other.rank
        @league_points <=> other.league_points
      else
        @rank <=> other.rank
      end
    else
      @tier <=> other.tier
    end
  end
end

KEY = 'YOUR_KEY_HERE'.freeze

def create_request(request)
  URI("https://na1.api.riotgames.com/#{request}?api_key=#{KEY}")
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

def get_summoner(summonerId)
  league_rank = JSON.parse(get(create_request("lol/league/v3/positions/by-summoner/#{summonerId}")))
                    .select { |x| x['queueType'] == 'RANKED_SOLO_5x5' }
                    .first

  Summoner.new(
    id: summonerId,
    name: league_rank['playerOrTeamName'],
    tier: league_rank['tier'],
    division: league_rank['rank'],
    lp: league_rank['leaguePoints']
  )
end
