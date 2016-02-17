class Guess < ActiveRecord::Base
  belongs_to :game
  
  validates :game, presence: true
  validates :letter, format: { with: /\A[[:lower:]]\z/,
    message: "must be single lower-case alphabetic letter" }
 
  # TODO: move following validation logic into a service?
  validate :disallow_guess_after_game_over, 
    if: :has_valid_game, on: :create
  
  validate :disallow_repeated_guess, 
    if: [:has_valid_game, :has_valid_letter], on: :create

  private
  
  def disallow_guess_after_game_over
    errors.add(:base, "Guess is disallowed after game over") if game.over?
  end
  
  def disallow_repeated_guess
    if game.guessed?(letter)
      errors.add(:letter, "#{letter} has been guessed before")
    end
  end
  
  def has_valid_game
    errors[:game].empty?
  end
  
  def has_valid_letter
    errors[:letter].empty?
  end
end