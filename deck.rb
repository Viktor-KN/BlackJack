require_relative 'card'

class Deck
  def initialize
    @cards = []
    fill_deck
  end

  def take_card
    cards.pop
  end

  def return_cards(cards)
    self.cards.push(*cards)
  end

  def shuffle!
    cards.shuffle!
  end

  protected

  attr_reader :cards

  def fill_deck
    Card.SUITS.each do |suit|
      Card.RANKS.each { |rank| cards << Card.new(rank, suit, Card.POINTS[rank]) }
    end
  end
end
