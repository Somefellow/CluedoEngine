# frozen_string_literal: true

class Bot
  attr_reader :knocked_out

  def initialize(player_id, player_count, possible_cards)
    @knocked_out = false # TODO: Use this properly.
  end

  # Called when it's your turn.
  # Return an array of 3 cards you'd like to guess.
  def make_guess
    raise NotImplementedError
  end

  # Called at the end of your turn.
  # Return an array of 3 cards to make a final guess.
  # Return nil to not make a guess yet.
  def make_final_guess
    raise NotImplementedError
  end

  # Game setup function
  # Deals a single card into your hand.
  # Called multiple times during setup.
  def deal_hand(card)
    raise NotImplementedError
  end

  # Marks that a player announced they do not have any of these cards.
  # Cards is an array.
  def do_not_have_these(player_id, cards)
    raise NotImplementedError
  end

  # Called when a player answer a different players guess.
  # Provides the player who answered the guess, and an array of cards which was the guess.
  def do_have_one_of_these(player_id, cards)
    raise NotImplementedError
  end

  # Called when a player answers one of your guesses.
  # Provides the player id, and which card they revealed from their hand.
  def reveal_card(player_id, card)
    raise NotImplementedError
  end

  # Called when it's your turn to answer another player's guess.
  # Cards is an array of their guess.
  # You should return a single card, or nil if you don't have it.
  def ask_for_card(cards)
    @cards_in_hand.each do |card|
      # puts "My card #{card}, cards - #{cards}, possible cards - #{@possible_cards}"
      return card if cards.include?(card)
    end
    nil
  end
end
