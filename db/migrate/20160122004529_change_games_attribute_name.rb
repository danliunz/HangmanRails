class ChangeGamesAttributeName < ActiveRecord::Migration
  def up
    rename_column :games, :max_allowed_misses, :max_misses
  end
  
  def down
    rename_column :games, :max_misses, :max_allowed_misses
  end
end
