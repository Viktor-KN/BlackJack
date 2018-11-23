class Deck
  def initialize
    @cards = []
    fill_deck
  end

  def get_card
    cards.pop
  end

  def shuffle_deck!
    cards.shuffle!
  end

  private

  attr_reader :cards

  def card_suits
    %i[spades hearts dimonds clubs]
  end

  def card_ranks
    %w[2 3 4 5 6 7 8 9 10 J Q K A]
  end

  def fill_deck
    card_suits.each do |suit|
      card_ranks.each { |rank| cards << Card.new(rank, suit) }
    end
  end
end
