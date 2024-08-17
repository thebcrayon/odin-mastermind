# frozen_string_literal: true

# Builds and prints Mastermind board
# Processes turns and gives feeback
class BoardUI
  def initialize(number_of_guesses = 12)
    @board = Array.new(number_of_guesses) { Array.new(4, '*'.colorize(:black)) }
  end

  def print_current_board
    @board.each_with_index do |row, row_index|
      puts divider
      print '| '
      print row.join(' ') << ' |'
      puts ' • • • •'.colorize(:black) # will be function to determine color of dots after user input
      puts divider if row_index == @board.size - 1
    end
  end

  def update_board
    @board[3][1] = 'B'.colorize(:blue)
  end

  private

  def divider
    '+–––––––––+'
  end
end
