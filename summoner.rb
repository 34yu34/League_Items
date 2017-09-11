require_relative 'utils'

class Summoner
  attr_accessor :summoner_id, :account_id, :name, :tier, :division, :league_points

  def initialize(options)
    @summoner_id = options[:summoner_id]
    @account_id = options[:account_id]
    @name = options[:name]
    @tier = Utils.get_tier_level(options[:tier])
    @division = Utils.get_rank_level(options[:division])
    @league_points = options[:lp]
  end

  def account_id
    unless @account_id
      @account_id =
        Utils.get(
          Utils.create_request("/lol/summoner/v3/summoners/#{@summoner_id}")
        )['accountId']
    end

    @account_id
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
