# frozen_string_literal: true

# Player information like name, win total
# move choice
class Player
  attr_accessor :name, :is_human

  def initialize
    @is_human = nil
  end

  def guess_code; end
end
