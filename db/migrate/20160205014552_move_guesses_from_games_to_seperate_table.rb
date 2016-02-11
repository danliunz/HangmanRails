class MoveGuessesFromGamesToSeperateTable < ActiveRecord::Migration
  def migrate_guesses_from_games_table_to_guesses_table
    Game.connection.transaction do 
      Game
        .connection
        .select_all("select id, guesses from games")
        .to_hash
        .each do |row|
          game_id = row["id"]
          
          row["guesses"].chars.each do |letter|
            Guess.connection.execute(
              "insert into guesses(letter, game_id, created_at) " +
              "values('#{letter}', #{game_id}, now())"
            )
          end
        end
    end
  end
  
  def up
    create_table :guesses do |t|
      t.string :letter, limit: 1, null: false
      t.references :game, null: false, foreign_key: true
      t.timestamps
      
      t.index [:game_id, :letter], unique: true
    end
    
    migrate_guesses_from_games_table_to_guesses_table
    
    remove_column :games, :guesses
  end
  
  def migrate_guesses_from_its_own_table_to_games_table
    Game.connection.transaction do
      Game
        .connection
        .select_all(
          "select game_id, group_concat(letter order by id asc separator '') " + 
          "from guesses group by game_id"
        )
        .rows
        .each do |row|
          game_id = row[0]
          guesses = row[1]
          
          Game.connection.execute(
            "update games set guesses='#{guesses}' " + 
            "where id = #{game_id}"
          )
        end
    end
  end
  
  def down
    add_column :games, :guesses, :string, limit: 64, default: '', null: false
    
    migrate_guesses_from_its_own_table_to_games_table
    
    drop_table :guesses
  end
end
