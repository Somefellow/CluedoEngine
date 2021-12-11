# frozen_string_literal: true

require './bot'

class NoDeductionRandomBot < Bot
  def initialize(player_id, player_count, possible_cards)
    @possible_cards = possible_cards
    # puts "I am player #{player_id + 1} out of #{player_count} - Controlled by #{self.class}"
    super
  end

  def make_guess
    [
      possible_persons.sample,
      possible_weapons.sample,
      possible_rooms.sample
    ]
  end

  def make_final_guess
    if possible_persons.count == 1 &&
       possible_weapons.count == 1 &&
       possible_rooms.count == 1
      [
        possible_persons[0],
        possible_weapons[0],
        possible_rooms[0]
      ]
    end
  end

  def deal_card(card)
    @cards_in_hand ||= []
    @cards_in_hand.push(card)
    @possible_cards.delete(card)
  end

  def do_not_have_these(player_id, cards)
    # I don't care.
  end

  def do_have_one_of_these(player_id, cards)
    # I don't care.
  end

  def reveal_card(_player_id, card)
    @possible_cards.delete(card)
  end

  def ask_for_card(cards)
    @cards_in_hand.each do |card|
      # puts "My card #{card}, cards - #{cards}, possible cards - #{@possible_cards}"
      return card if cards.include?(card)
    end
    nil
  end

  private

  def possible_persons
    @possible_cards.select { |card| card[0] == 'p' }
  end

  def possible_weapons
    @possible_cards.select { |card| card[0] == 'w' }
  end

  def possible_rooms
    @possible_cards.select { |card| card[0] == 'r' }
  end
end
