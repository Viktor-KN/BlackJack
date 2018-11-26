require_relative 'player'

class HumanPlayer < Player
  def turn
    ask('Your turn: ')
  end

  def dealer?
    false
  end

  def init_variants
    variants.clear
    variants.push(TAKE_CARD_VARIANT, PASS_TURN_VARIANT, OPEN_CARDS_VARIANT)
  end

  private

  def ask(question)
    variants.each.with_index(1) do |var, index|
      puts "#{index}.\t#{var[:title]}"
    end

    print question

    until (0..variants.size - 1).cover?(variant = gets.to_i - 1)
      print 'Incorrect choice. Try again: '
    end

    variants[variant]
  end
end
