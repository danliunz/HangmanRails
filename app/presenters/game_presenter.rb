class GamePresenter < SimpleDelegator
  def visible_to_player?(secret_letter)
    over? || guessed?(secret_letter)
  end
  
  def obscured_secret
    secret.gsub(/./) do |letter|
      visible_to_player?(letter) ? "#{letter}" : " _ "
    end
  end
  
  def guesses_as_string
    guesses.map(&:letter).join(" ")
  end
  
  def last_played_at
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end