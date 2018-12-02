require_relative 'black_jack_game'
require_relative 'terminal_view'
require_relative 'terminal_controller'

view = TerminalView.new
controller = TerminalController.new(view)
BlackJackGame.new(controller).run
