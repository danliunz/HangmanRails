class MakeGuess
  def initialize(game, guess_letter)
    @game = game
    @guess_letter = guess_letter
  end
  
  def call
    guess = Guess.new(game: @game, letter: @guess_letter)
    if validate(guess)
      @game.guesses << guess
      bring_game_to_top_of_history
    end
    
    guess
  end
  
  private
  
  def validate(guess)
    if guess.valid?
      validate_repeated_guess(guess)
      validate_game_not_over(guess)
    end
    
    guess.errors.empty?
  end
  
  def validate_game_not_over(guess)
    if guess.game.over?
      guess.errors.add(:base, "Guess is disallowed after game over")
    end
  end
  
  def validate_repeated_guess(guess)
    if guess.game.guessed?(guess.letter)
      guess.errors.add(:letter, "#{guess.letter} has been guessed before")
    end
  end
  
  def bring_game_to_top_of_history
    @game.touch
  end
end