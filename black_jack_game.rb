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
    puts '----------------- new round ----------------------'
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

  def show_players_info(opts = {})
    players.reverse_each do |player|
      if player.dealer? && opts[:mask_dealer_cards_points] == true
        cards = player.hand.show_cards(mask_cards: true)
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
    if player.hand.cards.size == cards_max && dealer.hand.cards.size == cards_max
      puts 'Each player have 3 cards. Opening cards.'
      return fsm.active_state = :end_round
    end
    show_players_info(mask_dealer_cards_points: true)
    players.each do |player|
      # return fsm.active_state = :end_round unless player.dealer? || player.hand.points <= 21

      variant = player.turn
      player.variants.delete(variant)
      puts "#{player.name} choose to #{variant[:title]}"
      if variant[:action] == :open_cards
        fsm.active_state = :end_round
        break
      elsif variant[:action] == :take_card
        take_card(player)
      end
    end
  end

  def take_card(player)
    card = deck.get_card
    puts "#{player.name} received new card: #{player.dealer? ? card.to_s(mask_cards: true) : card}"
    player.hand.cards << card
  end

  def end_round
    puts '---------------- end of round --------------------'
    show_players_info
    player_points = player.hand.points
    dealer_points = dealer.hand.points
    if player_points == dealer_points || (player_points > 21 && dealer_points > 21)
      bank.tie
      puts 'Tie! No one won. Bets returned to players.'
    elsif player_points > 21 || (player_points < dealer_points && dealer_points <= 21)
      bank.winner(dealer.name)
      puts 'You loose this round!'
    else
      bank.winner(player.name)
      puts 'You won this round!'
    end

    players.each do |player|
      if bank.balance(player.name) < bet_amount
        return fsm.active_state = player.dealer? ? :dealer_loose : :player_loose
      end

      deck.return_cards(player.hand.cards)
      player.hand.cards.clear
      player.init_variants
    end
    fsm.active_state = :new_round
  end
end
