class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def points
    solid_points = []
    variable_points = []
    points_variants = []

    cards.each do |card|
      if card.points.key?(:alt_val)
        variable_points << [card.points[:val], card.points[:alt_val]]
      else
        solid_points << card.points[:val]
      end
    end

    return solid_points.sum if variable_points.empty?

    variable_points_size = variable_points.size
    variable_points = variable_points.flatten.combination(variable_points_size).uniq
    variable_points.each do |elem|
      points_variants << (solid_points + elem).sum
    end

    points_variants.select { |var| var <= 21 }.max
  end

  def show_cards(opts = {})
    cards.reduce('') { |memo, card| "#{memo}#{memo.empty? ? '' : '  '}#{card.to_s(opts)}" }
  end

  private

  def calc_points(cards)
    # cards.reduce(0) do |sum, card|
    #   card_points = if card.points.key?(:add) && sum >= card.points[:overflow]
    #                   card.points[:overflow_value]
    #                 else
    #                   card.points[:value]
    #                 end
    #   sum + card_points
    # end
  end
end
