# frozen_string_literal: true

class Bot
  attr_reader :knocked_out

  def initialize(_player_id, _player_count, _possible_cards)
    @knocked_out = false
  end
end
