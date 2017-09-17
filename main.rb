require 'http'
require 'json'
require 'irb'
require 'byebug'

require_relative 'summoner'
require_relative 'match'
require_relative 'utils'

KEY = 'YOUR_KEY_HERE'.freeze

a = Utils.get_summoner(31464163)
c = Utils.get_ranked_match(a)

binding.irb
