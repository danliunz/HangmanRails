class Game < ActiveRecord::Base
  
  include GuessValidator
  
  # -guesses- : array of char or string
  def guesses=(guesses)
    super(Array(guesses).join)
  end
  
  def guesses
    super.chars
  end
  
  def submit_guess(guess)
    self.guesses = guesses << guess
    self
  end
  
  def guessed?(guess)
    guesses.include?(guess)
  end
  
  def missed_guesses
    guesses - secret.chars
  end

  def over?
    won? || lost?
  end
  
  def won?
    (secret.chars - guesses).empty?
  end
  
  def lost?
    missed_guesses.size >= max_misses
  end
end
