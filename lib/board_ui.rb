# frozen_string_literal: true

# Builds and prints Mastermind board
# Processes turns and gives feeback
class BoardUI
  COLORED_PEGS = { red: 'R', green: 'G', yellow: 'Y', blue: 'B', magenta: 'M', cyan: 'C' }.freeze
  def initialize(number_of_guesses)
    blank_symbol = 'o'
    @board = Array.new(number_of_guesses) { Array.new(4, blank_symbol.colorize(:black)) }
  end

  def print_current
    @board.each_with_index do |row, row_index|
      puts divider
      print '| '
      print row.join(' ') << ' |'
      puts ' • • • •'.colorize(:black) # will be function to determine color of dots after user input
      puts divider if row_index == @board.size - 1
    end
  end

  def update(index)
    @board[index] = @user_guess
  end

  private

  def divider
    '+–––––––––+'
  end
end
