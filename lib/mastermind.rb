# frozen_string_literal: true

# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind
  DEFAULT_GUESSES = 12
  MSG_GAME_PROMPTS =
    {
      prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12',
      prompt_welcome: "Welcome, guess the code in #{@number_of_guesses} ",
      prompt_make_guess: 'Enter your next guess',
      prompt_input_error: 'Error with input, try again',
      prompt_next_round: 'Ready for the next round? Press ENTER to continue',
      prompt_game_over: 'Game Over!',
      prompt_human_win: 'Congrats, you guessed correctly',
      prompt_loss: 'Sorry, it was not guessed correctly'
    }.freeze

  def self.play
    player_input = game_data
    player_name = player_input[0]
    user_round_input = player_input[1].to_i
    number_of_guesses = user_round_input.positive? ? user_round_input : DEFAULT_GUESSES
    board_ui = BoardUI.new(number_of_guesses)
    Mastermind.new(Player.new(player_name), board_ui, number_of_guesses)
  end

  def self.game_data
    prompts = MSG_GAME_PROMPTS.values_at(:prompt_player_name, :prompt_guesses)
    prompts.reduce([]) do |acc, prompt|
      puts prompt
      acc << gets.chomp
    end
  end

  private_class_method :game_data # :msg_game_prompts

  private

  def initialize(player, board_ui, number_of_guesses)
    @player_human = player
    @player_computer = Player.new('Computer')
    @board_ui = board_ui
    @number_of_guesses = number_of_guesses
    @master_code = %w[Y M C R]
    @user_guess = nil
    @current_guess_number = nil
    start
  end

  def start
    1.upto(total_guesses) do |i|
      @current_guess_number = i - 1
      clear_screen if i == 1
      prompt_user_guess
      @board_ui.print_current
      process_user_guess(gets.chomp)
      clear_screen
    end
  end

  def total_guesses
    @number_of_guesses
  end

  def process_user_guess(user_guess)
    @user_guess = user_guess.upcase
    if valid_entry? && number_of_exact_matches == 4
      game_over
    elsif valid_entry? && number_of_exact_matches < 4
      @board_ui.update(@user_guess, @current_guess_number)
    else
      prompt_input_error
      process_user_guess(gets.chomp)
    end
  end

  def number_of_exact_matches
    @user_guess.split('').each_with_index.reduce(0) do |acc, (item, index)|
      acc += 1 unless item != @master_code[index]
      acc
    end
  end

  def valid_entry?
    all_clear = four_digits? && uses_correct_letters?
    return true if all_clear

    false
  end

  def four_digits?
    @user_guess.size == 4
  end

  def uses_correct_letters?
    @user_guess.split('').all? { |letter| @board_ui.valid_letters.include?(letter) }
  end

  def game_over
    puts MSG_GAME_PROMPTS.values_at(:prompt_game_over)
  end

  def prompt_input_error
    puts MSG_GAME_PROMPTS.values_at(:prompt_input_error)
  end

  def prompt_user_guess
    puts MSG_GAME_PROMPTS.values_at(:prompt_user_guess)
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
