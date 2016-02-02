class GamePresenter < SimpleDelegator
  def need_obsecure_from_player?(secret_char)
    !over? && !guessed?(secret_char)
  end
  
  def last_played_at
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end
end