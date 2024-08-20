# frozen_string_literal: true

# Message that direct gameflow
module Messages
  def msg_game_prompts
    {
      prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12',
      prompt_welcome: 'Welcome, ',
      prompt_make_guess: 'Enter your next guess',
      prompt_next_round: 'Ready for the next round? Press ENTER to continue',
      prompt_game_over: 'Game Over!',
      prompt_win: 'Congrats, you guessed correctly',
      prompt_loss: 'Sorry, it was not guessed correctly'
    }
  end

  def msg_user_guess
    msg_game_prompts.values_at(:prompt_make_guess).join
  end

  def msg_next_round
    msg_game_prompts.values_at(:prompt_next_round).join
  end

  def msg_game_over
    msg_game_prompts.values_at(:prompt_next_round).join
  end

  def msg_welcome
    msg_game_prompts.values_at(:prompt_welcome).join
  end

  def msg_make_guess
    msg_game_prompts.values_at(:prompt_make_guess).join
  end

  def msg_win
    msg_game_prompts.values_at(:prompt_win).join
  end

  def msg_lose
    msg_game_prompts.values_at(:prompt_loss).join
  end
end
