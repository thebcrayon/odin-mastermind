# frozen_string_literal: true

require_relative 'lib/board_ui'

require 'colorize'

# 1. CodeMaker generates 6 digit color code: Red, Blue, Yellow, Green, Teal, Purple
# 2. CodeGuesser makes first guess
# 3. CodeMaker gives feedback
# 4. CodeGuesser makes second guess
# 5. CodeMaker gives feedback
# 6. etc…
board = BoardUI.new
board.print_current_board
# puts 'Break the Code: * * * *'
# puts '---–---––--- | Color Options: R(Red), O(Orange), Y,(Yellow)'
# print 'B Y R G'
# print "\t • •".colorize(:black)
# puts '       '
# puts "\t • •"
# puts '------–-––--'
# print 'B Y R G'
# print "\t • •".colorize(:black)
# puts '       '
# puts "\t • •"
# puts '------–-––--'
