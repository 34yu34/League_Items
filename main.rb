require 'http'
require 'json'
require 'irb'
require 'byebug'

require_relative 'summoner'
require_relative 'match'
require_relative 'utils'

KEY = 'YOUR_KEY_HERE'.freeze

a = Utils.read_summoners

binding.irb
