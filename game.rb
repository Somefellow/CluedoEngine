# frozen_string_literal: true

class Game
  PERSON_COUNT = 6
  WEAPON_COUNT = 6
  ROOM_COUNT = 9

  attr_reader :in_progress, :winning_player_id

  def initialize(*player_classes)
    @in_progress = true

    # init whole deck
    @whole_deck = []
    (0..PERSON_COUNT).each { |i| @whole_deck << "p#{i}".to_sym }
    (0..WEAPON_COUNT).each { |i| @whole_deck << "w#{i}".to_sym }
    (0..ROOM_COUNT).each { |i| @whole_deck << "r#{i}".to_sym }
    puts "Initialised whole deck: #{@whole_deck}"

    # init solution
    @solution = ["p#{rand(PERSON_COUNT)}".to_sym, "w#{rand(WEAPON_COUNT)}".to_sym, "r#{rand(ROOM_COUNT)}".to_sym]
    puts "Solution decided: #{@solution}"

    # init current deck without solution and shuffle
    @current_deck = @whole_deck.clone.reject { |c| @solution.include?(c) }.shuffle
    puts "Current deck: #{@current_deck}"

    # init players
    @players = player_classes.each_with_index.map do |player_class, i|
      player = player_class.new(@current_deck.pop(3), @whole_deck.clone)
      puts "Initialised player #{i}: #{player.inspect}"
      player
    end

    # init active player
    @active_player_id = rand(@players.count)
    puts "Active player: #{@active_player_id}"
  end

  def advance_turn
    # active player makes a guess
    guess = active_player.guess
    puts "Player #{@active_player_id} asks for #{guess}"

    # go around the table until somebody says they have one of these cards
    turn_sequence.each_with_index do |player, player_id|
      response = player.ask(guess)
      puts "Player #{player_id} responded with #{response}"

      # notify the player who asked of the response / revealed card
      active_player.reveal_information(player_id, guess, response)

      # notify each other player whether they revealed a card or not
      @players.each_index.reject { |player_id2| player_id2 == @active_player_id || player_id2 == player_id }.each do |player_id2|
        puts "Telling player #{player_id2} that #{player_id} responded to #{guess} by revealing a card: #{!response.nil?}"
        @players[player_id2].reveal_information(player_id, guess, !response.nil?)
      end

      # if there was a card revealed, stop going around the table
      break unless response.nil?
    end

    # allow the player to make their final guess
    # TODO: lose game if wrong
    final_guess = active_player.final_guess
    unless final_guess.nil?
      puts "#{active_player} found the solution: #{final_guess}"
      @in_progress = false
      @winning_player_id = @active_player_id
      return
    end

    # advance turn counter
    @active_player_id = (@active_player_id + 1) % @players.count
    puts "Active player: #{@active_player_id}"
  end

  def active_player
    @players[@active_player_id]
  end

  def turn_sequence
    ((@active_player_id + 1..@players.count - 1).to_a + (0..@active_player_id - 1).to_a).map { |i| @players[i] }
  end
end

class Array
  def people
    select { |x| x.start_with?('p') }
  end

  def weapons
    select { |x| x.start_with?('w') }
  end

  def rooms
    select { |x| x.start_with?('r') }
  end
end
