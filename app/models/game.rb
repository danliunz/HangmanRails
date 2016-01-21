class Game
  
  attr_reader :state
  
  def initialize(secret)
    @state = State.new(secret)
  end
  
end 