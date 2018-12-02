require_relative 'player'

class DealerPlayer < Player
  def initialize
    super('Dealer')
  end

  def dealer?
    true
  end
end
