require_relative 'summoner'
require_relative 'match'

require 'http'
require 'concurrent'

module Utils
  def self.create_request(request, params = [])
    params << "api_key=#{KEY}"
    URI("https://na1.api.riotgames.com/#{request}?#{params * '&'}")
  end

  def self.get(uri)
    Concurrent::Promise.new do
      print '.' # Only to passively show the progress
      result = HTTP.get(uri)
      until result.status.success?
        case result.status.code
        when 429
          sleep(result.headers['Retry-After'].to_i)
          result = HTTP.get(uri)
        when 403
          raise StandardError, 'Forbidden; Did your application key expire?'
        else
          raise StandardError, result.status.to_s
        end
      end
      JSON.parse(result.to_s)
    end.execute
  end

  def self.get_tier_level(tier)
    return tier if tier.is_a?(Integer)
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

  def self.get_rank_level(rank)
    return rank if rank.is_a?(Integer)
    %w(
      V
      IV
      III
      II
      I
    ).index(rank.upcase)
  end

  def self.get_summoner(summoner_id, account_id = nil)
    league_rank = get(create_request("lol/league/v3/positions/by-summoner/#{summoner_id}"))
                  .value
                  &.find { |x| x['queueType'] == 'RANKED_SOLO_5x5' }
    return nil unless league_rank
    Summoner.new(
      summoner_id: summoner_id,
      account_id: account_id,
      name: league_rank['playerOrTeamName'],
      tier: league_rank['tier'],
      division: league_rank['rank'],
      lp: league_rank['leaguePoints']
    )
  end

  def self.get_ranked_match(summoner)
    matchlist = []
    get(create_request("lol/match/v3/matchlists/by-account/#{summoner.account_id}", ['queue=420']))
      .value['matches']&.each do |m|
        match = get(create_request("lol/match/v3/matches/#{m['gameId']}")).value
        next if match.nil?
        matchlist << Match.new(
          game_id: match['gameId'],
          game_version: match['gameVersion'],
          summoners: match['participantIdentities']
        )
      end
    matchlist
  end

  def self.rank_summoners(matchlist)
    matchlist.map(&:summoners)
             .flatten
             .sort
  end

  def self.sort_summoners(summoners_list)
    summoners_list.sort_by(&:creation_time)
                  .reverse
                  .uniq(&:summoner_id)
                  .select { |summoner| summoner.tier > 2 }
                  .sort
  end

  def self.update_summoners(summoners_list = [])
    summoners_list += read_summoners.map { |sum| get_summoner(sum.summoner_id, sum.account_id) }
    write_summoners(sort_summoners(summoners_list))
  end

  def self.write_summoners(summoners_list)
    File.rename('db/summoners.json', 'db/summoners.json.bak')
    summoners_list.to_dh
                  .to_json
    File.open('db/summoners.json', 'w') { |f| f << summoners_list }
  end

  def self.read_summoners
    File.open('db/summoners.json', 'r') do |file|
      return JSON.parse(file.readline)
                 .map { |summoner| summoner.inject({}) { |memo, (key, value)| memo[key.to_sym] = value; memo } }
                 .map { |summoner| Summoner.new(summoner) }
    end
  end
end
