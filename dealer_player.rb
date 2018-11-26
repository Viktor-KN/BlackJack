require_relative 'player'

class DealerPlayer < Player
  def initialize
    super('Dealer')
  end

  def turn
    if hand.cards.size < 3 && hand.points < 17
      TAKE_CARD_VARIANT
    else
      PASS_TURN_VARIANT
    end
  end

  def dealer?
    true
  end
end
