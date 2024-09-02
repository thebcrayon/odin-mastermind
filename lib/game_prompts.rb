# frozen_string_literal: true

require 'colorize'

# Message that direct gameflow
module Gameprompts
  GAME_DATA_PROMPTS =
    { prompt_game_mode_options: ['Welcome to Mastermind - Select your game mode '.upcase.yellow,
                                 '1. Single Player - Codebreaker vs CPU         ',
                                 '2. Single Player - Codemaker vs CPU           ',
                                 '3. 1 v 1 - 2 Human Players                    '],
      prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12',
      prompt_code_setter: "\nCodemaker, Enter your secret code using only these letters:\n".yellow.underline,
      prompt_next_entry: "\nEnter your code attempt:\n",
      prompt_game_win: 'Game over, Codebreaker won!',
      prompt_game_loss: 'Game over, Codemaker won!',
      prompt_entry_error: 'Error with input, please type valid entry' }.freeze

  def self.prompt_game_mode_menu
    prompts = GAME_DATA_PROMPTS[:prompt_game_mode_options]
    prompts.each_with_index do |row, i|
      puts '+–––––––––––––––––––––––––––––––––––––––––––––––––+'
      print '| '
      puts " #{row} | "
      puts '+–––––––––––––––––––––––––––––––––––––––––––––––––+' if i == prompts.size - 1
    end
  end

  def self.show_instructions
    Gameprompts.clear_screen
    puts 'INSTRUCTIONS:'.yellow.underline
    puts "\nTry to guess the secret code using the following keys:\n"
    Gameprompts.print_peg_options
    Gameprompts.print_hint_text
  end

  def self.print_hint_text
    puts "\nHINTS:\n".yellow.underline
    puts "#{'*'.red} asterisk: A correct color in the correct position."
    puts "#{'*'.white} asterisk: A correct color in the wrong position."
    puts "NOTE: Hint order does not matter.\n".underline
  end

  def self.prompt_code_setter
    puts GAME_DATA_PROMPTS[:prompt_code_setter]
    Gameprompts.print_peg_options
  end

  def self.print_peg_options
    Mastermind::COLORED_PEGS.each do |key, value|
      print "#{value.colorize(key).underline} = #{key.capitalize}"
      print ' | ' unless value == 'C'
      puts "\n" if value == 'C'
    end
  end

  def self.prompt_guesses
    puts GAME_DATA_PROMPTS[:prompt_guesses]
    gets.chomp
  end

  def self.prompt_next_entry
    puts GAME_DATA_PROMPTS[:prompt_next_entry]
  end

  def self.prompt_input_error
    puts GAME_DATA_PROMPTS[:prompt_entry_error]
  end

  def self.prompt_game_win
    puts GAME_DATA_PROMPTS[:prompt_game_win]
  end

  def self.prompt_game_loss(code)
    message = GAME_DATA_PROMPTS[:prompt_game_loss]
    puts "#{message} The code was #{code.join.upcase}"
  end

  def self.clear_screen
    puts "\e[H\e[2J"
  end
end
