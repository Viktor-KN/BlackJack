class Card
  attr_reader :rank, :suit, :points

  def initialize(rank, suit, points)
    @rank = rank
    @suit = suit
    @points = points
  end

  def to_s
    "#{rank}-#{suit}"
  end
end
