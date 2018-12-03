class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def points
    solid_points, variable_points = sort_points_by_type

    return solid_points.sum if variable_points.empty?

    points_variants = []
    variable_points_size = variable_points.size
    variable_points = variable_points.flatten.combination(variable_points_size).uniq

    variable_points.each { |elem| points_variants << (solid_points + elem).sum }
    points_variants.select { |var| var <= 21 }.max
  end

  def show_cards(opts = {})
    cards.reduce('') do |memo, card|
      "#{memo}#{memo.empty? ? '' : '  '}#{opts[:mask_cards] ? '**' : card}"
    end
  end

  private

  def sort_points_by_type
    solid_points = []
    variable_points = []

    cards.each do |card|
      if card.points.key?(:alt_val)
        variable_points << [card.points[:val], card.points[:alt_val]]
      else
        solid_points << card.points[:val]
      end
    end
    [solid_points, variable_points]
  end
end
