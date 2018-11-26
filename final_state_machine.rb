class FinalStateMachine
  attr_accessor :active_state

  def initialize(caller)
    @caller = caller
  end

  def update
    caller.send active_state
  end

  private

  attr_reader :caller
end
