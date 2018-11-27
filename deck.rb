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

  def card_suits
    %i[spades hearts diamonds clubs]
  end

  def card_ranks
    %w[2 3 4 5 6 7 8 9 10 J Q K A]
  end

  def card_points
    {
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
    }
  end

  def fill_deck
    card_suits.each do |suit|
      card_ranks.each { |rank| cards << Card.new(rank, suit, card_points[rank]) }
    end
  end
end
