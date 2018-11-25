class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def points
    cards.reduce(0) do |sum, card|
      card_points = if card.points.key?(:overflow) && sum >= card.points[:overflow]
                      card.points[:overflow_value]
                    else
                      card.points[:value]
                    end
      sum + card_points
    end
  end
end
