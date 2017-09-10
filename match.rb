require_relative 'utils'

class Match
  attr_accessor :game_id, :game_version, :summoners

  def initialize(options)
    @game_id = options[:game_id]
    @game_version = options[:game_version]
    @summoners =
      options[:summoners]
      .map { |e| [e['player']['summonerId'], e['player']['accountId']] }
      .map { |summoner_id, account_id| Utils.get_summoner(summoner_id, account_id) }

  end
end
