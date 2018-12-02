class TerminalController
  def initialize(view)
    @view = view
  end

  def message(message_data)
    if message_data.is_a?(String)
      puts message_data
    else
      puts view.render(message_data)
    end
  end

  def ask_variants(question_data)
    variants = question_data[:variants]

    puts view.render_variants(variants)
    print question_data[:question]

    until (0..variants.size - 1).cover?(variant = gets.to_i - 1)
      print 'Incorrect choice. Try again: '
    end
    variants[variant]
  end

  def ask_simple(question_data)
    print question_data[:question]

    while (variant = gets.strip).empty?
      print 'Incorrect answer. Try again: '
    end
    variant
  end

  def ask_yes_no(question_data)
    print question_data[:question]

    until /Y|N/ =~ (choice = gets.strip.upcase)
      print 'Incorrect choice provided! Enter Y or N: '
    end
    choice
  end

  def pause
    puts 'Press Enter to continue...'
    gets
  end

  private

  attr_reader :view
end
