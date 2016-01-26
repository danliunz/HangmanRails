class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :secret, limit: 32, null: false
      t.string :guesses, limit: 64, default: '', null: false
      t.integer :max_allowed_misses, null: false

      t.timestamps
    end
  end
end
