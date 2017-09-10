require_relative 'utils'

class Match
  attr_accessor :game_id, :game_version, :summoners

  def initialize(options)
    @game_id = options[:game_id]
    @game_version = options[:game_version]
    @summoners =
      options[:summoners]
      .map { |e| e['player']['summonerId'] }
      .map { |summoner_id| Utils.get_summoner(summoner_id) }

  end
end
