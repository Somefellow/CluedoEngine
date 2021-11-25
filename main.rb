# frozen_string_literal: true

require './game_state'

PLAYER_COUNT = 6

game_state = GameState.new PLAYER_COUNT

puts "#{game_state.player_count} players"
(1..game_state.player_count).each do |i|
  puts "Player #{i}:"
  puts game_state.cards_in_hand(i - 1)
end
