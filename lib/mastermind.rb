# frozen_string_literal: true

require_relative 'game_prompts'

# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind # rubocop:disable Metrics/ClassLength
  include Gameprompts
  attr_accessor :code_breaker, :code_setter, :game_mode

  COLORED_PEGS = { red: 'R', green: 'G', yellow: 'Y', blue: 'B', magenta: 'M', cyan: 'C' }.freeze

  def self.play
    game = Mastermind.new
    Gameprompts.prompt_game_mode_menu
    game.validate_mode_selection
    @master_code = select_code(game)
    game.setup_board
    game.start
  end

  def self.select_code(game)
    if game.game_mode == 1
      game.code_breaker.is_human = true
      game.generate_code
    elsif game.game_mode == 2
      Gameprompts.prompt_code_setter
      game.code_breaker.is_human = false
      game.create_code
    else
      Gameprompts.prompt_code_setter
      game.code_breaker.is_human = true
      game.create_code
    end
  end

  def initialize
    @code_breaker = Player.new # true/false should prob be a method
    @code_setter = Player.new
    @total_guesses = 4
    @master_code = nil
    @user_code = nil
    @code_check = nil
    @current_round = nil
  end

  def setup_board
    @board_ui = BoardUI.new(@total_guesses, COLORED_PEGS)
    @board_ui.master_code = @master_code # Board gets its own copy of code to test with
  end

  def validate_mode_selection
    entry = gets.chomp.to_i
    if entry.between?(1, 3)
      @game_mode = entry
      # entry
    else
      puts GAME_DATA_PROMPTS[:prompt_entry_error]
      validate_mode_selection
    end
  end

  def create_code
    entry = gets.chomp.upcase.split('')
    if valid_entry?(entry)
      @master_code = entry
      entry
    else
      puts GAME_DATA_PROMPTS[:prompt_entry_error]
      create_code
    end
  end

  def generate_code
    letters = COLORED_PEGS.to_a.flatten.select { |item| item.to_s.length == 1 }
    random_array = []
    4.times { random_array.push(letters[rand(0..letters.size - 1)]) }
    @master_code = random_array
  end

  def start
    1.upto(@total_guesses) do |i|
      @current_round = i - 1
      Gameprompts.show_instructions
      @board_ui.print_current
      if win?
        Gameprompts.prompt_game_win
        break
      end
      next_round
    end
  end

  def process_guess(guess)
    @user_code = guess.upcase.split('')
    unless valid_entry?(@user_code)
      Gameprompts.prompt_input_error
      enter_new_code
    end
    @board_ui.update(@user_code, @current_round)
    Gameprompts.clear_screen
    Gameprompts.show_instructions
    @board_ui.print_current
    check_win
  end

  def next_round
    if @code_breaker.is_human
      Gameprompts.prompt_next_entry
      enter_new_code
    else
      computer_guess
    end
  end

  def enter_new_code
    code_guess = gets.chomp
    process_guess(code_guess)
  end

  def valid_entry?(current_code)
    all_clear = four_digits?(current_code) && uses_correct_letters?(current_code)
    return true if all_clear

    false
  end

  def four_digits?(current_code)
    current_code.size == 4
  end

  def uses_correct_letters?(current_code)
    current_code.all? { |letter| COLORED_PEGS.values.include?(letter) }
  end

  def check_win
    if win?
      Gameprompts.prompt_game_win
    elsif @current_round + 1 == @total_guesses && !win?
      Gameprompts.prompt_game_loss(@master_code)
    end
  end

  def win?
    @master_code == @user_code
  end
end
