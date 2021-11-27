# frozen_string_literal: true

require './game_state'

PLAYER_COUNT = 6

game_state = GameState.new PLAYER_COUNT

(1..game_state.player_count).each do |i|
  puts "Player #{i}: #{game_state.cards_in_hand(i - 1)}"
end

puts "Solution: #{game_state.solution}"

puts "Possible cards: #{game_state.possible_cards}"
