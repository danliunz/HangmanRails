class GamePresenter
  LAST_PLAY_TIME_FORMAT = "%Y-%m-%d %H:%M:%S"
  OBSCURED_SECRET_LETTER = " _ "

  delegate :won?, :lost?, :secret, to: :@game

  def initialize(game)
    @game = game
  end

  def delegate
    @game
  end

  def visible_to_player?(secret_letter)
    @game.over? || @game.guessed?(secret_letter)
  end

  def obscured_secret
    @game.secret.chars.map do |letter|
      visible_to_player?(letter) ? letter : OBSCURED_SECRET_LETTER
    end.join
  end

  def guesses_as_string
    @game.guesses.order(id: :asc).map(&:letter).join(" ")
  end

  def last_played_at
    @game.updated_at.strftime(LAST_PLAY_TIME_FORMAT)
  end
end