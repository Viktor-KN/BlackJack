class DealerPlayer < Player
  def initialize
    super('Dealer')
  end

  def turn(variants)
    if hand.cards.size < 3 && hand.points < 17
      variants.select { |_key, var| var[:action] == :take_card }
    else
      variants.select { |_key, var| var[:action] == :pass_turn }
    end
  end
end
