class AddStatusToGame < ActiveRecord::Migration
  def change
    add_column :games, :status, :integer, null: false, default: 0
    
    update_game_status
  end
  
  def update_game_status
    Game.all.each do |game|
      game.refresh_status
      game.save!
    end
  end
end
