# frozen_string_literal: true

# Message that direct gameflow
module Messages
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

  def msg_game_loss(code)
    puts "Game over, you lost. The code was #{code.join}"
  end
end
