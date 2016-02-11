class Game < ActiveRecord::Base
  has_many :guesses
  
  validates :secret, format: { with: /\A[[:lower:]]+\z/, 
    message: "must be of lower-case alphabetic letters" }
    
  validates :num_of_lives, numericality: { only_integer: true,
    greater_than: 0 }
  
  def guesses
    super.order(id: :asc)
  end
  
  def submit_guess(letter)
    guesses.create(letter: letter)
  end
  
  def guessed?(letter)
    guesses.any? { |guess| guess.letter == letter }
  end
  
  def missed_guesses
    guesses.reject { |guess| secret.include?(guess.letter) }
  end

  def over?
    won? || lost?
  end
  
  def won?
    secret.chars.all? { |secret_letter| guessed?(secret_letter) }
  end
  
  def lost?
    missed_guesses.size >= num_of_lives
  end
end
