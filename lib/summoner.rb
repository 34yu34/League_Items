require 'hashable'
require_relative 'utils'

class Summoner
  include Hashable
  attr_accessor :summoner_id, :account_id, :name, :tier, :division,
                :league_points, :creation_time

  def initialize(options)
    @summoner_id = options[:summoner_id]
    @account_id = options[:account_id]
    @name = options[:name]
    @tier = Utils.get_tier_level(options[:tier])
    @division = Utils.get_rank_level(options[:division])
    @league_points = options[:lp]
    @creation_time = Time.now
  end

  def account_id
    unless @account_id
      @account_id =
        Utils.get(
          Utils.create_request("lol/summoner/v3/summoners/#{@summoner_id}")
        ).value['accountId']
    end

    @account_id
  end

  def <=>(other)
    if @tier == other.tier
      if @division == other.division
        @league_points <=> other.league_points
      else
        @division <=> other.division
      end
    else
      @tier <=> other.tier
    end
  end
end
