class GamePresenter < SimpleDelegator
  def need_not_obsecure?(secret_char)
    over? || guessed?(secret_char)
  end
  
  def last_played_at
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end