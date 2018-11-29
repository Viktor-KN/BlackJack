class Card
  attr_reader :rank, :suit, :points

  SUIT_GLYPHS = {
    spades: '♠',
    hearts: '♥',
    diamonds: '♦',
    clubs: '♣'
  }.freeze

  SUITS = %i[spades hearts diamonds clubs].freeze

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  POINTS = {
    '2' => { val: 2 },
    '3' => { val: 3 },
    '4' => { val: 4 },
    '5' => { val: 5 },
    '6' => { val: 6 },
    '7' => { val: 7 },
    '8' => { val: 8 },
    '9' => { val: 9 },
    '10' => { val: 10 },
    'J' => { val: 10 },
    'Q' => { val: 10 },
    'K' => { val: 10 },
    'A' => { val: 11, alt_val: 1 }
  }.freeze

  def initialize(rank, suit, points)
    @rank = rank
    @suit = suit
    @points = points
  end

  def to_s
    "#{rank}#{SUIT_GLYPHS[suit]}"
  end
end
