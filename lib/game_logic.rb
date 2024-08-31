# frozen_string_literal: true

# Game flow and logic module
module Gamelogic
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
