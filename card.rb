class Card
  attr_reader :rank, :suit, :points

  SUIT_GLYPHS = {
    spades: '♠',
    hearts: '♥',
    diamonds: '♦',
    clubs: '♣'
  }.freeze

  def initialize(rank, suit, points)
    @rank = rank
    @suit = suit
    @points = points
  end

  def to_s(opts = {})
    opts[:hide_cards] ? '**' : "#{rank}#{SUIT_GLYPHS[suit]}"
  end

end
