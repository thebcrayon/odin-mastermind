# frozen_string_literal: true

# Player information like name, win total
# move choice
class Player
  attr_reader :name

  def initialize(name)
    @name = name
    @player_type = nil
    @code = nil
  end
end
