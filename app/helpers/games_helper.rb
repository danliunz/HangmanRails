module GamesHelper
  def game_status_image_tag(game)
    image_tag(
      "hang_#{game.missed_guesses.size + 1}.gif",
      alt: "#{game.missed_guesses.size} missed guesses",
      class: "game-status-img"
    )
  end
  
  def obscured_game_secret(game)
    game.secret.gsub(/./) do |letter|
      game.visible_to_player?(letter) ? "#{letter}" : " _ "
    end
  end
  
  def game_input_button_css_class(game, letter)
    css = "btn btn-default"
    css << " invisible " if game.guessed?(letter)
    css << " disabled " if game.over?
    
    css
  end
end
