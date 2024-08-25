# frozen_string_literal: true

require_relative 'messages'
# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind
  DEFAULT_GUESSES = 12

  GAME_DATA_PROMPTS =
    { prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12' }.freeze

  def self.play
    player_input = game_data
    player_name = player_input[0]
    user_round_input = player_input[1].to_i
    number_of_guesses = user_round_input.positive? ? user_round_input : DEFAULT_GUESSES
    board_ui = BoardUI.new(number_of_guesses)
    Mastermind.new(Player.new(player_name), board_ui, number_of_guesses)
  end

  def self.game_data
    prompts = GAME_DATA_PROMPTS.values_at(:prompt_player_name, :prompt_guesses)
    prompts.reduce([]) do |acc, prompt|
      puts prompt
      acc << gets.chomp
    end
  end

  private_class_method :game_data # , :msg_game_prompts

  private

  def initialize(player, board_ui, number_of_guesses)
    @player_human = player
    @player_computer = Player.new('Computer')
    @board_ui = board_ui
    @user_code = nil
    @number_of_guesses = number_of_guesses
    @current_round = nil
    @board_ui.master_code = @board_ui.generate_code
    @master_code = @board_ui.master_code
    start
  end

  def start
    1.upto(total_guesses) do |i|
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
    elsif @current_round + 1 == total_guesses && !win?
      msg_game_loss
    end
  end

  def win?
    @master_code == @user_code
  end

  def total_guesses
    @number_of_guesses
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
    @user_code.all? { |letter| @board_ui.valid_letters.include?(letter) }
  end

  def msg_next_entry
    puts "\nEnter your code attempt:\n"
    process_guess(gets.chomp)
  end

  def msg_input_error
    puts 'Error with input, please enter valid letters'
  end

  def msg_game_win
    puts 'Game over, You won!'
  end

  def msg_game_loss
    puts "Game over, you lost. The code was #{@master_code.join}"
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
