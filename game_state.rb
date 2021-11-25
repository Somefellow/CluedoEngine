# frozen_string_literal: true

# Stores information on the game state, generates turn info by taking commands.
class GameState
  PERSON_COUNT = 6
  WEAPON_COUNT = 6
  ROOM_COUNT = 9

  def initialize(player_count)
    init_game(player_count)
  end

  def reset_game
    player_count = @player_data.count
    init_game(player_count)
  end

  def player_count
    @player_data.count
  end

  def cards_in_hand(player_id)
    @player_data[player_id]
  end

  private

  def init_game(player_count)
    @player_data = []
    (1..player_count).each { |_i| @player_data.push([]) }

    possible_cards = []
    (1..PERSON_COUNT).each { |i| possible_cards.push("p#{i}") }
    (1..WEAPON_COUNT).each { |i| possible_cards.push("w#{i}") }
    (1..ROOM_COUNT).each { |i| possible_cards.push("r#{i}") }

    possible_cards = possible_cards.shuffle

    @solution = [] # TODO

    possible_cards.each_with_index do |card, index|
      @player_data[index % player_count].push(card)
    end
  end
end
