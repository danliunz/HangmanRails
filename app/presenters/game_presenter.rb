class GamePresenter < SimpleDelegator
  def visible_to_player?(secret_letter)
    over? || guessed?(secret_letter)
  end
  
  def last_played_at
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end