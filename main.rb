# frozen_string_literal: true

# Development
require 'pry'

# Import game
require './game'

# Import players
require './dummy_player'

# Simulate game
game = Game.new(DummyPlayer, DummyPlayer, DummyPlayer)
puts

while game.in_progress
  # gets
  game.advance_turn
  puts
end

puts "Turn: #{game.turn_count}"
