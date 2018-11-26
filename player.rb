require_relative 'hand'

class Player
  attr_reader :name, :hand

  def initialize(name)
    @name = name
    @hand = Hand.new
  end

  def turn
    raise NotImplementedError
  end
end
