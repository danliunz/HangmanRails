class MakeGuess
  def initialize(game, guess_letter)
    @game = game
    @guess_letter = guess_letter
  end

  def call
    @errors = []

    @game.with_lock do
      validate_guess_allowed

      if @errors.empty?
        guess = @game.guesses.create(letter: @guess_letter)
        @errors = guess.errors.full_messages
      end
    end

    @errors.empty?
  end

  def error_message
    @errors.join("\n")
  end

  private

  def validate_guess_allowed
    validate_game_not_over
    validate_repeated_guess
  end

  def validate_game_not_over
    if @game.over?
      @errors << "Guess is disallowed after game over"
    end
  end

  def validate_repeated_guess
    if @game.guessed?(@guess_letter)
      @errors << "#{@guess_letter} has been guessed before"
    end
  end
end