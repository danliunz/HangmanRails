class SubmitGuess
  def self.call(game, guess_letter)
    guess = Guess.new(game: game, letter: guess_letter)
    game.guesses << guess if validate(guess)
    
    guess
  end
  
  private
  
  def self.validate(guess)
    if guess.valid?
      disallow_repeated_guess(guess)
      disallow_guess_after_game_over(guess)
    end
    
    guess.errors.empty?
  end
  
  def self.disallow_guess_after_game_over(guess)
    if guess.game.over?
      guess.errors.add(:base, "Guess is disallowed after game over")
    end
  end
  
  def self.disallow_repeated_guess(guess)
    if guess.game.guessed?(guess.letter)
      guess.errors.add(:letter, "#{guess.letter} has been guessed before")
    end
  end
end