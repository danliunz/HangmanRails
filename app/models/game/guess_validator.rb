class Game
  module GuessValidator 
    def invalid_guess?(guess)
      if over?
        errors[:guess] = "submission is disallowed as game is over"
      elsif !single_alpha(guess)
        errors[:guess] = "'#{guess}' is not single alphabetic character"
      elsif guessed?(guess)
        errors[:guess] = "'#{guess}' has been guessed before"
      end
      
      errors[:guess].any?
    end
    
    private
    
    def single_alpha(guess)
      guess =~ /^[[:alpha:]]$/
    end
  end
end