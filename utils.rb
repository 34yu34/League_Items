module Utils
  def self.create_request(request, params = [])
    params << "api_key=#{KEY}"
    URI("https://na1.api.riotgames.com/#{request}?#{params * '&'}")
  end

  def self.get(uri)
    result = Net::HTTP.get(uri)
    parsed_result = JSON.parse(result)
  end

  def self.get_tier_level(tier)
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
    %w(
      I
      II
      III
      IV
      V
    ).index(rank.upcase) + 1
  end

  def self.get_summoner(summoner_id)
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

  def self.get_ranked_match(summoner)
    matchlist = []
    match_history = JSON.parse(get(create_request("/lol/match/v3/matchlists/by-account/#{summoner.account_id}", ['queue=420'])))["matches"]
      .each do |m|
          match = JSON.parse(get(create_request("/lol/match/v3/matches/#{match[gameId]}")))
          matchlist << Match.new(
            game_id: match['gameId'],
            game_version: match['gameVersion'],
            summoners: match['participantIdentities']
          )
      end
  end
end
