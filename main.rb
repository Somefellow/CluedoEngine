# frozen_string_literal: true

require './cluedo_engine'
require './bots/no_deduction_random_bot'
require './bots/deduction_random_bot'

puts((1..10_000).map do |_|
  CluedoEngine.new(
    [
      NoDeductionRandomBot,
      NoDeductionRandomBot,
      NoDeductionRandomBot,
      NoDeductionRandomBot,
      NoDeductionRandomBot,
      DeductionRandomBot
    ]
  ).winning_player_class
end.tally)
