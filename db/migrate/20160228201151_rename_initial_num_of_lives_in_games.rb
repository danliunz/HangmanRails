class RenameInitialNumOfLivesInGames < ActiveRecord::Migration
  def change
    rename_column :games, :initial_num_of_lives, :initial_number_of_lives
  end
end
