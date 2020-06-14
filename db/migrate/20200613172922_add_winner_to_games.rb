class AddWinnerToGames < ActiveRecord::Migration[6.0]
  def change
    add_reference :games, :winner, references: :players, foreign_key: { to_table: :players }
  end
end
