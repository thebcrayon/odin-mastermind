# frozen_string_literal: true

require_relative 'lib/mastermind'
require_relative 'lib/board_ui'
require_relative 'lib/player'

require 'colorize'

# 1. CodeMaker generates 6 digit color code: Red, Blue, Yellow, Green, Teal, Purple
# 2. CodeGuesser makes first guess
# 3. CodeMaker gives feedback
# 4. CodeGuesser makes second guess
# 5. CodeMaker gives feedback
# 6. etc…
Mastermind.play
