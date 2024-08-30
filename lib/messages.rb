# frozen_string_literal: true

# Message that direct gameflow
module Messages
  GAME_DATA_PROMPTS =
    { prompt_game_mode: ['Welcome to Mastermind - Select you game mode ',
                         '1. Single Player - Codeguesser               ',
                         '2. Single Player - Codemaker                 ',
                         '3. 1 v 1 - 2 Human Players                   '],
      prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12' }.freeze

  def self.msg_game_mode
    prompts = GAME_DATA_PROMPTS[:prompt_game_mode]
    prompts.each_with_index do |row, i|
      puts '+––––––––––––––––––––––––––––––––––––––––––––––––+'
      print '| '
      puts " #{row} | "
      puts '+––––––––––––––––––––––––––––––––––––––––––––––––+' if i == prompts.size - 1
    end
  end

  def msg_next_entry
    puts "\nEnter your code attempt:\n"
  end

  def msg_input_error
    puts 'Error with input, please enter valid letters'
  end

  def msg_game_win
    puts 'Game over, You won!'
  end

  def msg_game_loss(code)
    puts "Game over, you lost. The code was #{code.join}"
  end

  def self.clear_screen
    puts "\e[H\e[2J"
  end
end
