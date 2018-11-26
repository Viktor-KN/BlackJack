class HumanPlayer < Player
  def turn(variants)
    ask('Your turn: ', variants)
  end

  private

  def ask(question, variants)
    variants.each { |key, val| puts "#{key}.\t#{val[:title]}" }

    print question

    until variants.key?(variant = gets.strip)
      print 'Incorrect choice. Try again: '
    end

    variant
  end
end
