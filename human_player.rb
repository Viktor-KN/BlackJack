require_relative 'player'

class HumanPlayer < Player
  def dealer?
    false
  end

  def init_variants
    variants.clear
    variants.push(TAKE_CARD_VARIANT, PASS_TURN_VARIANT)
  end
end
