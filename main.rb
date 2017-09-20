require 'http'
require 'json'
require 'irb'
require 'byebug'

require_relative 'lib/summoner'
require_relative 'lib/match'
require_relative 'lib/utils'

KEY = 'YOUR_KEY_HERE'.freeze

a = Utils.read_summoners

binding.irb
