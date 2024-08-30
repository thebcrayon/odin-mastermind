# frozen_string_literal: true

require_relative 'messages'
# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind
  include Messages

  COLORED_PEGS = { red: 'R', green: 'G', yellow: 'Y', blue: 'B', magenta: 'M', cyan: 'C' }.freeze

  def self.play
    game_input = game_data_array
    game_mode = game_input[0].to_i
    player_name = game_input[1]
    user_round_input = game_input[2].to_i
    total_rounds = user_round_input.positive? ? user_round_input : 12 # default 12 was constant, saving space
    players = [Player.new(player_name, true), Player.new('Computer', false)] # true/false should prob be a method
    Mastermind.new(game_mode, players, total_rounds)
  end

  def self.game_data_array
    prompts = GAME_DATA_PROMPTS.values_at(:prompt_game_mode, :prompt_player_name, :prompt_guesses)
    prompts.reduce([]) do |acc, prompt|
      puts prompt
      acc << gets.chomp
    end
  end

  private_class_method :game_data_array

  private

  def initialize(game_mode, players, total_rounds)
    setup_players(players)
    setup_rounds(total_rounds)
    setup_board(game_mode)
    start
  end

  def setup_players(players)
    @code_breaker = players[0]
    @code_setter = players[1]
    @master_code = @code_setter.generate_code(COLORED_PEGS)
    @user_code = nil
  end

  def setup_rounds(total_rounds)
    @total_rounds = total_rounds
    @current_round = nil
  end

  def setup_board(game_mode)
    @board_ui = BoardUI.new(@total_rounds, COLORED_PEGS)
    @board_ui.master_code = @master_code # Board gets its own copy of code to test with
    @game_mode = GAME_DATA_PROMPTS[:prompt_game_mode][game_mode]
  end

  def start
    1.upto(@total_rounds) do |i|
      @current_round = i - 1
      Messages.clear_screen
      @board_ui.print_current(@game_mode)
      if win?
        msg_game_win
        break
      end
      next_round
    end
  end

  def process_guess(guess)
    @user_code = guess.upcase.split('')
    unless valid_entry?
      msg_input_error
      enter_new_code
    end
    @board_ui.update(@user_code, @current_round)
    Messages.clear_screen
    @board_ui.print_current(@game_mode)
    check_win
  end

  def next_round
    if @code_breaker.is_human
      msg_next_entry
      enter_new_code
    else
      computer_guess
    end
  end

  def enter_new_code
    @code_breaker.code = gets.chomp
    process_guess(@code_breaker.code)
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
end
