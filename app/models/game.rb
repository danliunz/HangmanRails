class Game < ActiveRecord::Base
  has_many :guesses, dependent: :destroy

  validates :secret, format: {
    with: /\A[[:lower:]]+\z/,
    message: "must be of lower-case alphabetic letters"
  }

  validates :initial_number_of_lives, numericality: {
    only_integer: true,
    greater_than: 0
  }

  scope :ordered_by_last_play_time_desc, -> { order(updated_at: :desc) }

  def guessed?(letter)
    guesses.map(&:letter).include?(letter)
  end

  def missed_guesses
    guesses.select { |guess| secret.exclude?(guess.letter) }
  end

  def over?
    won? || lost?
  end

  def won?
    secret.chars.all? { |secret_letter| guessed?(secret_letter) }
  end

  def lost?
    missed_guesses.size >= initial_number_of_lives
  end
end
