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
        return fsm.active_state = player.dealer? ? :dealer_loose : :player_loose
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
    init_cards.times { players.each(&method(:take_card)) }
  end

  def show_player_info(opts = {})
    players.reverse_each do |player|
      if player.dealer? && opts[:hide_cards_points] == true
        cards = player.hand.show_cards(hide_cards: true)
        points = 'XX'
      else
        cards = player.hand.show_cards
        points = player.hand.points
      end
      puts player.name
      printf("  Cards: %-12sPoints: %-4sBet: %-6sBalance: %s\n",
             cards, points, bank.bet(player.name), bank.balance(player.name))
    end
  end

  def round_loop
    show_player_info(hide_cards_points: true)
    variant = nil
    players.each do |player|
      return fsm.active_state = :end_round unless player.dealer? || player.hand.points <= 21

      variant = player.turn
      player.variants.delete(variant)
      puts "#{player.name} choose to #{variant[:title]}"
      send variant[:action], player
    end
    sleep 2
  end

  def take_card(player)
    card = deck.get_card
    puts "#{player.name} received new card: #{player.dealer? ? card.to_s(hide_cards: true) : card}"
    player.hand.cards << card
  end

  def pass_turn(player)

  end

  def open_cards(_player)
    fsm.active_state = :end_round
  end
end
