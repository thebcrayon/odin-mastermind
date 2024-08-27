# frozen_string_literal: true

# Player information like name, win total
# move choice
class Player
  attr_accessor :name, :code

  def initialize(name, is_human)
    @name = name
    @is_human = is_human
    @code = nil
  end

  def generate_code(pegs)
    letters = pegs.to_a.flatten.select { |item| item.to_s.length == 1 }
    random_array = []
    4.times { random_array.push(letters[rand(0..letters.size - 1)]) }
    random_array
  end

  def guess_code; end
end
