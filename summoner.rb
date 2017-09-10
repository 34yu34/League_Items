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
