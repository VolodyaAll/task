# frozen_string_literal: true

# Division model class
class Division < ApplicationRecord
  belongs_to :tournament
  has_many :games, dependent: :destroy
  has_and_belongs_to_many :teams
  accepts_nested_attributes_for :games

  validates :name, presence: true, inclusion: { in: %w(A B Playoff) }

  def all_games_played?
    games.none? { |game| game.winner.nil? }
  end

  def top(quantity = teams.size / 2)
    Team.select('teams.id, teams.name, count(*) AS wins')
        .joins('JOIN games ON teams.id = games.winner_id')
        .where(games: { division_id: id })
        .group(:id)
        .order('wins DESC')
        .limit(quantity)
  end

  def playoff?
    name == 'Playoff'
  end

  def final_playoff_stage?
    games.length == 1
  end
end
