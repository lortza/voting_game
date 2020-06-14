class Player < ApplicationRecord
  belongs_to :game, inverse_of: :players
  has_many :games, foreign_key: :winner_id, dependent: :destroy
  has_many :rounds, foreign_key: :winner_id, dependent: :destroy
  has_many :submissions, foreign_key: :nominee_id, dependent: :destroy
  has_many :submissions, foreign_key: :nominator_id, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :game_id,
    message: "This name is already taken by another player. Please enter another." }
end
