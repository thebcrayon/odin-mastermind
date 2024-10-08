# frozen_string_literal: true

# Builds and prints Mastermind board
# Processes turns and gives feeback
class BoardUI
  COLORED_PEGS = { red: 'R', green: 'G', yellow: 'Y', blue: 'B', magenta: 'M', cyan: 'C' }.freeze

  attr_accessor :master_code

  def initialize(number_of_guesses)
    @blank_symbol = 'o'
    @hint_symbol_blank = '• '.colorize(:black)
    @hint_symbol_correct = '* '
    @board = Array.new(number_of_guesses) { Array.new(4, @blank_symbol.colorize(:black)) }
    @hints = Array.new(number_of_guesses) { Array.new(4, @hint_symbol_blank.colorize(:black)) }
    @master_code = []
    @user_code = nil
  end

  def print_current
    show_instructions
    @board.each_with_index do |row, row_index|
      puts '+–––––––––+'
      print '| '
      print row.join(' ') << ' | '
      puts @hints[row_index].join
      puts '+–––––––––+' if row_index == @board.size - 1
    end
  end

  def update(user_code, index)
    @user_code = user_code
    @board[index] = colored_letters_array
    @hints[index] = hint_array
  end

  def valid_letters
    COLORED_PEGS.values
  end

  def generate_code
    letters = COLORED_PEGS.to_a.flatten.select { |item| item.to_s.length == 1 }
    random_array = []
    4.times { random_array.push(letters[rand(0..letters.size - 1)]) }
    random_array
  end

  private

  def show_instructions
    puts 'INSTRUCTIONS:'.yellow.underline
    puts "\nTry to guess the secret code using the following keys:\n"
    COLORED_PEGS.each do |key, value|
      print "#{value.colorize(key).underline} = #{key.capitalize}"
      print ' | ' unless value == 'C'
      puts "\n" if value == 'C'
    end
    hints_text
  end

  def hints_text
    puts "\nHINTS:\n".yellow.underline
    puts "#{'*'.red} asterisk: A correct color in the correct position."
    puts "#{'*'.white} asterisk: A correct color in the wrong position."
    puts "NOTE: Hint order does not matter.\n".underline
  end

  def colored_letters_array
    @user_code.reduce([]) do |arr, letter|
      arr << letter.colorize(COLORED_PEGS.key(letter))
    end
  end

  def apply_colors_to_hints(arr)
    totals = { red: arr[0], white: arr[1] }
    blank_spaces = 4 - arr.sum + 1 # + 1 for array indexes starting at zero.. Booo
    colored_dots = totals.reduce([]) do |acc, (key, value)|
      acc.push(@hint_symbol_correct.colorize(key) * value)
    end
    # fill the rest of the array with blank dots and return
    colored_dots.fill(@hint_symbol_blank, (colored_dots.size..blank_spaces)).join.split('')
  end

  def letters_exact
    @user_code.each_with_index.reduce(0) do |acc, (letter, index)|
      acc += 1 unless letter != @master_code[index]
      acc
    end
  end

  # removing letters that are EXACT match in user_code
  def filtered_master_code
    @master_code.select.with_index do |letter, index|
      letter if @master_code[index] != @user_code[index]
    end
  end

  # removing letters that are EXACT in master_code
  # removing letter that are NOT in Master
  def filtered_user_code
    @user_code.select.with_index do |letter, index|
      letter if @master_code[index] != @user_code[index] && filtered_master_code.include?(letter)
    end
  end

  # we need the filtered code arrays as hashes
  # to compare values to generate hint totals
  def hint_array
    master_tally = filtered_master_code.tally
    user_tally = filtered_user_code.tally
    arr = [letters_exact, letters_correct(master_tally, user_tally)]
    apply_colors_to_hints(arr)
  end

  # compares hashed tallys and returns total number
  # of letters that are correct but in the wrong place
  # This considers multiples of the same letter
  # if master and user codes have and equal count,
  # the count is returned, otherwise
  def letters_correct(master_tally, user_tally)
    user_tally.reduce(0) do |acc, (key, _value)|
      count_equal = master_tally[key] == user_tally[key]
      min_value = [master_tally[key], user_tally[key]].min
      max_value = [master_tally[key], user_tally[key]].max
      count_difference = min_value % max_value
      acc += count_equal ? master_tally[key] : count_difference
      acc
    end
  end
end
