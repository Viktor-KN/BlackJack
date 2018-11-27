require_relative 'card'

class Deck
  def initialize
    @cards = []
    fill_deck
  end

  def get_card
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
      '2' => { value: 2 },
      '3' => { value: 3 },
      '4' => { value: 4 },
      '5' => { value: 5 },
      '6' => { value: 6 },
      '7' => { value: 7 },
      '8' => { value: 8 },
      '9' => { value: 9 },
      '10' => { value: 10 },
      'J' => { value: 10 },
      'Q' => { value: 10 },
      'K' => { value: 10 },
      'A' => { value: 11, overflow: 10, overflow_value: 1 }
    }
  end

  def fill_deck
    card_suits.each do |suit|
      card_ranks.each { |rank| cards << Card.new(rank, suit, card_points[rank]) }
    end
  end
end
