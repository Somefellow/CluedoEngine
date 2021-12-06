# frozen_string_literal: true

require './cluedo_engine'
require './bots/no_deduction_random_bot'

PLAYER_COUNT = 6
PLAYER_CLASS = NoDeductionRandomBot

(1..100).each { |_i| CluedoEngine.new((1..PLAYER_COUNT).map { |_j| PLAYER_CLASS }.to_a) }
