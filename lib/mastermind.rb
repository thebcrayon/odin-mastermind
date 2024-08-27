# frozen_string_literal: true

require_relative 'messages'
# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind
  include Messages

  COLORED_PEGS = { red: 'R', green: 'G', yellow: 'Y', blue: 'B', magenta: 'M', cyan: 'C' }.freeze
  GAME_DATA_PROMPTS =
    { prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12' }.freeze

  def self.play
    player_input = game_data
    player_name = player_input[0]
    user_round_input = player_input[1].to_i
    total_rounds = user_round_input.positive? ? user_round_input : 12 # default 12 was constant, saving space
    players = [Player.new(player_name, true), Player.new('Computer', false)] # true/false should prob be a method
    Mastermind.new(players, total_rounds)
  end

  def self.game_data
    prompts = GAME_DATA_PROMPTS.values_at(:prompt_player_name, :prompt_guesses)
    prompts.reduce([]) do |acc, prompt|
      puts prompt
      acc << gets.chomp
    end
  end

  def setup_players(players)
    @code_breaker = players[0]
    @code_setter = players[1]
  end

  def setup_rounds(total_rounds)
    @total_rounds = total_rounds
    @current_round = nil
  end

  def setup_codes
    @master_code = @code_setter.generate_code(COLORED_PEGS)
    @user_code = nil
  end

  def setup_board
    @board_ui = BoardUI.new(@total_rounds, COLORED_PEGS)
    @board_ui.master_code = @master_code
  end

  private_class_method :game_data

  private

  def initialize(players, total_rounds)
    setup_players(players)
    setup_rounds(total_rounds)
    setup_codes
    setup_board
    start
  end

  def start
    1.upto(@total_rounds) do |i|
      @current_round = i - 1
      clear_screen
      @board_ui.print_current
      if win?
        msg_game_win
        break
      end
      msg_next_entry
    end
  end

  def process_guess(guess)
    @user_code = guess.upcase.split('')
    unless valid_entry?
      msg_input_error
      process_guess(gets.chomp)
    end
    @board_ui.update(@user_code, @current_round)
    clear_screen
    @board_ui.print_current
    check_win
  end

  def check_win
    if win?
      msg_game_win
    elsif @current_round + 1 == @total_rounds && !win?
      msg_game_loss(@master_code)
    end
  end

  def win?
    @master_code == @user_code
  end

  def valid_entry?
    all_clear = four_digits? && uses_correct_letters?
    return true if all_clear

    false
  end

  def four_digits?
    @user_code.size == 4
  end

  def uses_correct_letters?
    @user_code.all? { |letter| COLORED_PEGS.values.include?(letter) }
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
