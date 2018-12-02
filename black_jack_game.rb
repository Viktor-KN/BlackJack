require_relative 'bank'
require_relative 'deck'
require_relative 'human_player'
require_relative 'dealer_player'
require_relative 'finite_state_machine'

class BlackJackGame
  def initialize(controller)
    @fsm = FiniteStateMachine.new(self)
    @c = controller
    @fsm.active_state = :init_game
  end

  def run
    loop do
      fsm.update
    end
  end

  private

  attr_accessor :bank, :player, :dealer, :players, :deck
  attr_reader :fsm, :c

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

  # Game states

  def init_game
    c.message 'Welcome to Blackjack game!'
    player_name = c.ask_simple(question: 'Enter your name: ')
    self.player = HumanPlayer.new(player_name.capitalize)
    self.dealer = DealerPlayer.new
    self.players = [player, dealer]
    fsm.active_state = :new_game
  end

  def new_game
    self.bank = Bank.new
    self.deck = Deck.new
    players.each { |player| bank.add_player(player.name, init_amount) }

    fsm.active_state = :new_round
  end

  def new_round
    init_players
    c.message(type: :new_round)
    deck.shuffle!
    deal_cards
    bank.make_bets(bet_amount)

    fsm.active_state = :round_loop
  end

  def round_loop
    if players_have_max_cards?
      c.message "Each player have 3 cards. Opening cards.\n"
      return fsm.active_state = :end_round
    end
    show_players_info(mask_dealer_cards_points: true)

    players.each do |player|
      variant = player.dealer? ? send(:dealer_turn) : send(:player_turn)
      c.message "#{player.name} choose to #{variant[:title]}"

      if variant[:action] == :open_cards
        fsm.active_state = :end_round
        break
      elsif variant[:action] == :take_card
        take_card(player)
      end
    end
  end

  def end_round
    c.message(type: :end_round)

    msg = get_round_result
    show_players_info
    c.message msg

    players.each do |player|
      if bank.balance(player.name) < bet_amount
        return fsm.active_state = player.dealer? ? :dealer_loose : :player_loose
      end
    end
    fsm.active_state = :new_round
    c.pause
  end

  def dealer_loose
    ask_choice('win')
  end

  def player_loose
    ask_choice('loose')
  end

  # Helper methods

  def init_players
    players.each do |player|
      deck.return_cards(player.hand.cards)
      player.hand.cards.clear
      player.init_variants
    end
  end

  def player_turn
    player.variants << Player::OPEN_CARDS_VARIANT if second_turn?
    variant = c.ask_variants(question: 'Your turn: ', variants: player.variants)
    player.variants.delete(variant)
  end

  def dealer_turn
    if dealer.hand.cards.size < 3 && dealer.hand.points < 17
      Player::TAKE_CARD_VARIANT
    else
      Player::PASS_TURN_VARIANT
    end
  end

  def second_turn?
    player.variants.size < 2 && !player.variants.include?(Player::OPEN_CARDS_VARIANT)
  end

  def deal_cards
    init_cards.times { players.each(&method(:take_card)) }
  end

  def show_players_info(opts = {})
    players.reverse_each do |player|
      cards, points = if player.dealer? && opts[:mask_dealer_cards_points]
                        [player.hand.show_cards(mask_cards: true), 'XX']
                      else
                        [player.hand.show_cards, player.hand.points]
                      end
      params = { player: player.name, cards: cards, points: points,
                 bet: bank.bet(player.name), balance: bank.balance(player.name) }
      c.message(type: :player_info, params: params)
    end
  end

  def players_have_max_cards?
    player.hand.cards.size == cards_max && dealer.hand.cards.size == cards_max
  end

  def take_card(player)
    card = deck.take_card
    card_name = player.dealer? ? '**' : card.to_s
    c.message "#{player.name} received new card: #{card_name}"
    player.hand.cards << card
  end

  def get_round_result
    player_points = player.hand.points
    dealer_points = dealer.hand.points

    if player_points == dealer_points || (player_points > 21 && dealer_points > 21)
      bank.tie
      'Tie! No one won. Bets returned to players.'
    elsif player_points > 21 || (player_points < dealer_points && dealer_points <= 21)
      bank.winner(dealer.name)
      'You loose this round!'
    else
      bank.winner(player.name)
      'You won this round!'
    end
  end

  def ask_choice(game_result)
    choice = c.ask_yes_no(question: "You #{game_result} this game. Would you like to start new" \
                          ' one? (Y/N): ')
    return fsm.active_state = :new_game if choice == 'Y'

    exit(0)
  end
end
