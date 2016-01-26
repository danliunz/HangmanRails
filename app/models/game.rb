class Game < ActiveRecord::Base
  
  # 'guesses' is stored as string in DB, but array of char 
  # presenting player's guesses is more intuitive in business logic
  def guesses=(new_guesses)
    super(new_guesses.join)
  end
  
  def guesses
    super.chars
  end
  
  def submit_guess(guess)
    self.guesses = self.guesses << guess
    refresh_status
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
  
  def refresh_status
    self.status = case
      when won?; 1
      when lost?; 2
      else; 0
    end
  end
end
