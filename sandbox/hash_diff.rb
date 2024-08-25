# frozen_string_literal: true

@master_code = %w[B B Y B]
@user_guess  = %w[C R B G] # correct_exact = 3 | correct = 0

require 'colorize'
# To find the difference and tally the correct letters,
# we only need to compare elements that are NOT an exact match
# So we filter out wrong letters AND letters that aren't exact match
#
#
# 1. array of master letters that are NOT exact matches
# 2. array of user code elements that are NOT exact matches but ARE in the filtered master set
#

letters_exact = @user_guess.each_with_index.reduce(0) do |acc, (letter, index)|
  acc += 1 unless letter != @master_code[index]
  acc
end

filtered_master = @master_code.select.with_index do |letter, index|
  letter if @master_code[index] != @user_guess[index]
end

filtered_user = @user_guess.select.with_index do |letter, index|
  letter if @master_code[index] != @user_guess[index] && filtered_master.include?(letter)
end

con_master_tally = filtered_master.tally
con_user_tally = filtered_user.tally

letters_correct = con_user_tally.reduce(0) do |acc, (key, _value)|
  count_equal = con_master_tally[key] == con_user_tally[key]
  min_value = [con_master_tally[key], con_user_tally[key]].min
  max_value = [con_master_tally[key], con_user_tally[key]].max
  count_difference = min_value % max_value
  acc += count_equal ? con_master_tally[key] : count_difference
  acc
end

puts "Master Tally: #{con_master_tally}"
puts "User Tally: #{con_user_tally}"

puts "Exact Letters = #{letters_exact}"
puts "Out of place Letters' = #{letters_correct}"

# puts "\nINSTRUCTIONS:\nTry to guess the secret code using the following keys:\n".yellow.underline
# COLORED_PEGS = { red: 'R', green: 'G', yellow: 'Y', blue: 'B', magenta: 'M', cyan: 'C' }.freeze

# letters = COLORED_PEGS.to_a.flatten.select { |item| item.to_s.length == 1 }
# random_array = []
# 4.times { random_array.push(letters[rand(0..letters.size - 1)]) }

# p random_array
