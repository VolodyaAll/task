class Division < ApplicationRecord
  belongs_to :tournament
  has_many :games, dependent: :destroy
  has_and_belongs_to_many :teams
  accepts_nested_attributes_for :games

  validates :name, presence: true, inclusion: { in: %w(A B Playoff) }

  def playoff?
    name == 'Playoff'
  end

  def all_games_played?
    !games.any? { |game| game.winner.nil? }
  end
end
