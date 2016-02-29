class Guess < ActiveRecord::Base
  belongs_to :game
  
  validates :game, presence: true
  validates :letter, format: {
    with: /\A[[:lower:]]\z/,
    message: "must be single lower-case alphabetic letter"
  }
end