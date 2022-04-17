# frozen_string_literal: true

class Game
  PERSON_COUNT = 6
  WEAPON_COUNT = 6
  ROOM_COUNT = 9

  attr_reader :in_progress, :turn_count, :winning_player_id

  def initialize(*player_classes)
    @in_progress = true
    @turn_count = 0

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
    current_deck = @whole_deck.clone.reject { |c| @solution.include?(c) }.shuffle
    puts "Current deck: #{current_deck}"

    # init player classes
    @players = player_classes.map do |player_class|
      player_class.new(@whole_deck.clone)
    end

    # roll starting player
    @active_player_id = rand(@players.count)

    # deal cards going around the table with the starting player
    until current_deck.empty?
      active_player.deal_card(current_deck.pop)
      advance_active_player
    end

    @players.each_with_index do |player, i|
      puts "Initialised player #{i}: #{player.inspect}"
    end

    # next person after the last dealt card starts the game
    puts "Active player: #{@active_player_id}"
  end

  def advance_turn
    # active player makes a guess
    guess = active_player.guess
    puts "Player #{@active_player_id} asks for #{guess}"

    # go around the table until somebody says they have one of these cards
    puts "Turn sequence #{turn_sequence}"
    turn_sequence.each do |asked_player_id|
      response = @players[asked_player_id].ask(guess)
      puts "Player #{asked_player_id} responded with #{response}"

      # notify the player who asked of the response / revealed card
      puts "Telling player #{@active_player_id} that player #{asked_player_id} responded to #{guess} by revealing a card: #{response.nil? ? 'nil' : response}"
      active_player.reveal_information(asked_player_id, guess, response)

      # notify each other player whether they revealed a card or not
      @players.each_index do |listening_player_id|
        next if listening_player_id == @active_player_id || listening_player_id == asked_player_id

        puts "Telling player #{listening_player_id} that player #{asked_player_id} responded to #{guess} by revealing a card: #{!response.nil?}"
        @players[listening_player_id].reveal_information(asked_player_id, guess, !response.nil?)
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

    puts 'Finished turn'
    @players.each_with_index do |player, i|
      puts "Player #{i}: #{player.inspect}"
    end

    # advance turn counter
    advance_active_player
    @turn_count += 1
    puts "New active player: #{@active_player_id}"
  end

  def active_player
    @players[@active_player_id]
  end

  def turn_sequence
    (@active_player_id + 1..@players.count - 1).to_a + (0..@active_player_id - 1).to_a
  end

  private

  def advance_active_player
    @active_player_id = (@active_player_id + 1) % @players.count
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
