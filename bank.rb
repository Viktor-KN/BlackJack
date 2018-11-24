class Bank
  def initialize
    @players = {}
    @bets = Hash.new(0)
  end

  def add_player(name, balance)
    players[name] = balance unless players.key?(name)
  end

  def make_bets(amount)
    players.each_key do |name|
      players[name] -= amount
      bets[name] += amount
    end
  end

  def winner(name)
    players[name] += bets_amount
    bets.clear
  end

  def tie
    bets.each { |name, amount| players[name] += amount }
    bets.clear
  end

  def balance(name)
    players[name]
  end

  def bets_amount
    bets.values.sum
  end

  private

  attr_reader :players, :bets
end
