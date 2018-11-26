require_relative 'hand'

class Player
  TAKE_CARD_VARIANT = { action: :take_card, title: 'Take card' }.freeze
  PASS_TURN_VARIANT = { action: :pass_turn, title: 'Pass turn' }.freeze
  OPEN_CARDS_VARIANT = { action: :open_cards, title: 'Open cards' }.freeze

  attr_reader :name, :hand, :variants

  def initialize(name)
    @name = name
    @hand = Hand.new
    @variants = []
    init_variants
  end

  def turn
    raise NotImplementedError
  end

  def init_variants; end
end
