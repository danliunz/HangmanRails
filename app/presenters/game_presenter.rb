class GamePresenter < SimpleDelegator
  def visible_to_player?(secret_letter)
    over? || guessed?(secret_letter)
  end
  
  def obscured_secret
    secret.chars.map do |letter|
      visible_to_player?(letter) ? letter : " _ "
    end.join
  end
  
  def guesses_as_string
    guesses.order(id: :asc).map(&:letter).join(" ")
  end
  
  def last_played_at
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end