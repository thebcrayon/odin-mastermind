# frozen_string_literal: true

# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind
  DEFAULT_GUESSES = 12
  def initialize(player, board_ui, number_of_guesses)
    @player_human = player
    @player_computer = Player.new('Computer')
    @board_ui = board_ui
    @number_of_guesses = number_of_guesses
    @master_code = %w[Y M C R]
    @user_guess = %w[Y M C R]
    start
  end

  def start
    @board_ui.print_current
    # 1.upto(total_guesses) do
    #   @board_ui.print_current
    #   sleep 2
    # end
  end

  def self.play
    player_input = prompt_user_data
    player_name = player_input[0]
    user_round_input = player_input[1].to_i
    number_of_guesses = user_round_input.positive? ? user_round_input : DEFAULT_GUESSES
    board_ui = BoardUI.new(number_of_guesses)
    Mastermind.new(Player.new(player_name), board_ui, number_of_guesses)
  end

  def self.prompt_user_data
    prompts = ['Enter Player Name:', 'Enter Number of guesses. Hit any key for default of 12']
    prompts.reduce([]) do |acc, prompt|
      puts prompt
      acc << gets.chomp
    end
  end

  private_class_method :prompt_user_data

  private

  def total_guesses
    @number_of_guesses
  end

  def process_user_guess
    game_over if number_of_exact_matches == 4
  end

  def number_of_exact_matches
    @user_guess.each_with_index.reduce(0) do |acc, (item, index)|
      acc += 1 unless item != @master_code[index]
      acc
    end
  end

  def clear_screen
    puts "\e[H\e[2J"
  end
end
