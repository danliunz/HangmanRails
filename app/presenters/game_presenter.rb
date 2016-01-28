class GamePresenter < SimpleDelegator
  def obscured_secret
    secret.gsub(/./) { |c| guessed?(c) ? "#{c} " : "_ " }
  end
  
  def guesses
    super.join(" ")
  end
  
  def last_played_at
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end