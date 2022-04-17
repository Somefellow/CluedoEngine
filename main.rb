# frozen_string_literal: true

# Import game
require './game'

# Import players
require './dummy_player'

# Simulate game
game = Game.new(DummyPlayer, DummyPlayer, DummyPlayer)
game.advance_turn while game.in_progress
