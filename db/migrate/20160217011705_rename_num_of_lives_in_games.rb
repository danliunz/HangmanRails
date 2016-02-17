class RenameNumOfLivesInGames < ActiveRecord::Migration
  def change
    rename_column :games, :num_of_lives, :initial_num_of_lives
  end
end
