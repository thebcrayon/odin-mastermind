# frozen_string_literal: true

require_relative 'messages'
require_relative 'game_logic'
# Main game class to process and
# output guesses, set up players
# and control main game flow.
class Mastermind
  include Messages
  include Gamelogic

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
    setup_players(game_mode, players)
    setup_rounds(total_rounds)
    setup_board(game_mode)
    start
  end

  def setup_players(game_mode, players)
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
end
