class Game
  class Validator
    def self.invalid_guess?(guess, game)
      if not_single_alpha(guess)
        game.errors[:guess] = "'#{guess}' is not single alphabetic character"
      elsif game.guessed?(guess)
        game.errors[:guess] = "'#{guess}' has been guessed before"
      end
      
      game.errors[:guess].any?
    end
    
    private
    
    def self.not_single_alpha(guess)
      !(guess =~ /^[[:alpha:]]$/)
    end
  end
end