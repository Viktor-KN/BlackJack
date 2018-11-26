class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def points
    points = calc_points(cards)
    if points > 21
      alt_points = calc_points(cards.reverse)
      return [points, alt_points].min
    end
    points
  end

  def show_cards(opts = {})
    cards.reduce('') { |memo, card| "#{memo}#{memo.empty? ? '' : '  '}#{card.to_s(opts)}" }
  end

  private

  def calc_points(cards)
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
