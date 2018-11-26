require_relative 'bank'
require_relative 'deck'
require_relative 'human_player'
require_relative 'dealer_player'
require_relative 'final_state_machine'

class BlackJackGame
  def initialize
    @fsm = FinalStateMachine.new(self)
    @fsm.active_state = :init
  end

  def run
    puts 'Welcome to Blackjack game!'

    print 'Enter your name: '
    player_name = gets.strip.capitalize
    self.player = HumanPlayer.new(player_name)
    self.dealer = DealerPlayer.new

    self.players = [player, dealer]
    loop do
      fsm.update
    end
  end

  private

  attr_accessor :bank, :player, :dealer, :players, :deck
  attr_reader :fsm

  def init_amount
    100
  end

  def bet_amount
    10
  end

  def init_cards
    2
  end

  def cards_max
    3
  end

  def variant
  end

  def init
    self.bank = Bank.new
    self.deck = Deck.new

    players.each do |player|
      player.hand.cards.clear
      bank.add_player(player.name, init_amount)
    end

    fsm.active_state = :new_round
  end

  def new_round
    players.each do |player|
      if bank.balance(player.name) < bet_amount
        return fsm.active_state = player.is_a?(DealerPlayer) ? :dealer_loose : :player_loose
      end

      deck.return_cards(player.hand.cards)
      player.hand.cards.clear
    end
    puts 'New round.'
    puts 'Shuffling deck.'
    deck.shuffle!
    puts 'Dealing cards.'
    deal_cards
    puts 'Making bets.'
    bank.make_bets(bet_amount)

    fsm.active_state = :round_loop
  end

  def deal_cards
    init_cards.times do
      players.each do |player|
        player.hand.cards << deck.get_card
      end
    end
  end

  def round_loop

  end
end
