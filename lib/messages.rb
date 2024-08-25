# frozen_string_literal: true

# Message that direct gameflow
module Messages
  def msg_game_prompts
    { prompt_player_name: 'Enter Player Name',
      prompt_guesses: 'Enter Number of guesses. Hit any key for default of 12',
      prompt_welcome: 'Welcome, ',
      prompt_make_guess: 'Enter your next guess',
      prompt_input_error: 'Error with input, try again',
      prompt_next_round: 'Ready for the next round? Press ENTER to continue',
      prompt_game_over: 'Game Over!',
      prompt_human_win: 'Congrats, you guessed correctly',
      prompt_loss: 'Sorry, it was not guessed correctly' }
  end
end
