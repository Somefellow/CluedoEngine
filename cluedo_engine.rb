# frozen_string_literal: true

# TODO: knocked out logic.
class CluedoEngine
  PERSON_COUNT = 6
  WEAPON_COUNT = 6
  ROOM_COUNT = 9

  def initialize(players)
    init_game(players)
    play_game
  end

  def player_count
    @players.count
  end

  private

  # Generate the deck of cards.
  def init_possible_cards
    @possible_cards = []
    (1..PERSON_COUNT).each { |i| @possible_cards.push("p#{i}") }
    (1..WEAPON_COUNT).each { |i| @possible_cards.push("w#{i}") }
    (1..ROOM_COUNT).each { |i| @possible_cards.push("r#{i}") }
  end

  # Given that possible cards is set, generate a solution packet.
  def init_solution
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
      @players[index % @players.count].deal_card(card)
    end
    # puts @players.inspect
  end

  # Shuffles the deck, initialises the solution packet and deals cards to each player starting at Player 1.
  # Therefore, if the number of cards in deck and players doesn't divide neatly,
  # the last players will be the ones to receive 1 less card.
  def init_game(players)
    init_possible_cards
    init_solution
    init_players(players)
    deal_remaining_cards
  end

  def init_players(players)
    @players = players.map.with_index do |player_class, i|
      player_class.new(i, players.count, @possible_cards.map(&:clone))
    end
  end

  def play_game
    current_turn_player_id = rand(@players.count)
    turn_count = 1
    while @players.count > 1 # TODO: Knocked out.
      # puts "It's player #{current_turn_player_id}'s turn."

      guess = @players[current_turn_player_id].make_guess
      answer = nil

      turn_sequence(current_turn_player_id).each do |player_id|
        answer = @players[player_id].ask_for_card(guess)
        # puts "Ask player #{player_id} for #{guess} - Answer #{answer}"
        # puts "answer.nil? #{answer.nil?}"
        if answer.nil?
          @players.each { |player| player.do_not_have_these(player_id, guess) }
        else
          @players[current_turn_player_id].reveal_card(current_turn_player_id, answer)
          break
        end
      end

      final_guess = @players[current_turn_player_id].make_final_guess
      unless final_guess.nil?
        puts "Player #{current_turn_player_id + 1} making final guess #{final_guess} on turn #{turn_count}, times around the table: #{(turn_count / @players.count).floor} - Solution #{@solution}"
        return
      end

      # Set next turn.
      current_turn_player_id = if current_turn_player_id == @players.count - 1
                                 0
                               else
                                 current_turn_player_id + 1
                               end

      turn_count += 1
    end
  end

  def turn_sequence(player_id)
    (player_id + 1..@players.count - 1).to_a + (0..player_id - 1).to_a
  end
end
