# frozen_string_literal: true

class DummyPlayer
  attr_reader :cards_in_hand, :possible_cards

  def initialize(possible_cards)
    @cards_in_hand = []
    @possible_cards = possible_cards # .reject { |c| @cards_in_hand.include?(c) }
  end

  def deal_card(card)
    @cards_in_hand << card
    @possible_cards.delete(card)
  end

  def guess
    [
      @possible_cards.weapons.sample,
      @possible_cards.people.sample,
      @possible_cards.rooms.sample
    ]
  end

  def reveal_information(_player_id, _guess, response)
    return unless response.is_a? Symbol

    puts "Deleting #{response} from #{@possible_cards.inspect}"
    @possible_cards.delete(response)
  end

  def final_guess
    @possible_cards if @possible_cards.count == 3
  end

  def ask(cards)
    cards.each do |card|
      return card if @cards_in_hand.include?(card)
    end
    nil
  end
end
