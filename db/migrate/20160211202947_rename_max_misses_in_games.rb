class RenameMaxMissesInGames < ActiveRecord::Migration
  def change
    rename_column :games, :max_misses, :num_of_lives
  end
end
