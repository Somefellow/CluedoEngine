# frozen_string_literal: true

# Stores information on the game state, generates turn info by taking commands.
class GameState
  PERSON_COUNT = 6
  WEAPON_COUNT = 6
  ROOM_COUNT = 9

  attr_reader :solution

  def initialize(player_count)
    init_game(player_count)
  end

  # Regenerate solution and redeal, assuming the same number of players.
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

  # Generate a shuffled deck of cards.
  def generate_possible_cards
    possible_cards = []
    (1..PERSON_COUNT).each { |i| possible_cards.push("p#{i}") }
    (1..WEAPON_COUNT).each { |i| possible_cards.push("w#{i}") }
    (1..ROOM_COUNT).each { |i| possible_cards.push("r#{i}") }
    possible_cards.shuffle
  end

  # Given a shuffled decks, generate a solution packet.
  def generate_solution_from_possible_cards(possible_cards)
    [
      possible_cards.find { |card| card.chars.first == 'p' },
      possible_cards.find { |card| card.chars.first == 'w' },
      possible_cards.find { |card| card.chars.first == 'r' }
    ]
  end

  # Shuffles the deck, initialises the solution packet and deals cards to each player starting at Player 1.
  # Therefore, if the number of cards in deck and players doesn't divide neatly,
  # the last players will be the ones to receive 1 less card.
  def init_game(player_count)
    @player_data = []
    (1..player_count).each { |_i| @player_data.push([]) }

    possible_cards = generate_possible_cards

    @solution = generate_solution_from_possible_cards(possible_cards)

    # Skipping the solution cards, deal the rest to the players.
    possible_cards.reject { |card| @solution.include?(card) }.each_with_index do |card, index|
      puts "Index #{index}, card #{card}, mod #{index % player_count}"
      @player_data[index % player_count].push(card)
    end
  end
end
