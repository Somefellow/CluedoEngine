# frozen_string_literal: true

# Stores information on the game state, generates turn info by taking commands.
class GameState
  PERSON_COUNT = 6
  WEAPON_COUNT = 6
  ROOM_COUNT = 9

  attr_reader :solution, :possible_cards

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
    @player_data[player_id].shuffle
  end

  def make_guess(guess, player_id)
    # Loop through every player that isn't you in turn order.
    [*player_id + 1..player_count - 1, *0..player_id - 1].each do |i|
      puts "make_guess #{i} #{guess}"
    end
    raise NotImplementedError
  end

  private

  # Generate the deck of cards.
  def set_possible_cards
    @possible_cards = []
    (1..PERSON_COUNT).each { |i| possible_cards.push("p#{i}") }
    (1..WEAPON_COUNT).each { |i| possible_cards.push("w#{i}") }
    (1..ROOM_COUNT).each { |i| possible_cards.push("r#{i}") }
  end

  # Given that possible cards is set, generate a solution packet.
  def set_solution
    possible_cards = @possible_cards.shuffle
    @solution = [
      possible_cards.find { |card| card.chars.first == 'p' },
      possible_cards.find { |card| card.chars.first == 'w' },
      possible_cards.find { |card| card.chars.first == 'r' }
    ]
  end

  # Once the deck is generated and solution is set, deal the remaining cards to the players.
  def deal_remaining_cards
    @possible_cards
      .reject { |card| @solution.include?(card) }
      .shuffle
      .each_with_index do |card, index|
      @player_data[index % player_count].push(card)
    end
  end

  # Shuffles the deck, initialises the solution packet and deals cards to each player starting at Player 1.
  # Therefore, if the number of cards in deck and players doesn't divide neatly,
  # the last players will be the ones to receive 1 less card.
  def init_game(player_count)
    # Create empty array for each player.
    @player_data = []
    (1..player_count).each { |_i| @player_data.push([]) }

    set_possible_cards
    set_solution
    deal_remaining_cards
  end
end
