# frozen_string_literal: true

# Tournament model class
class Tournament < ApplicationRecord
  TEAMS_COUNT = 16 # must be equal to 2 to the power of n, where n is an integer greater than 1

  has_many :divisions, dependent: :destroy
  has_many :playoffs, -> { where(name: 'Playoff') }, class_name: 'Division', dependent: :destroy
  belongs_to :winner, class_name: 'Team', optional: true
  belongs_to :finalist, class_name: 'Team', optional: true
  has_and_belongs_to_many :teams

  validate :teams_conditions
  validates :name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w(draft in_progress done) }

  def create_a_playoff_stage?
    playoffs.size < Math.log2(TEAMS_COUNT) - 1 && divisions.all?(&:all_games_played?)
  end

  def finish(finalist, winner)
    update(status: 'done', finalist: finalist, winner: winner)
  end

  def start
    update(status: 'in_progress')
  end

  def teams_for_playoff_stage
    playoff_began? ? playoff_stage_winners : divisions_winners
  end

  private

  def teams_conditions
    errors.add(:teams, 'Only unique teams can participate in the tournament') if teams.uniq.length != TEAMS_COUNT
  end

  def playoff_began?
    playoffs.size.positive?
  end

  def playoff_stage_winners
    playoffs.last.top.sort_by(&:wins)
  end

  def divisions_winners
    divisions.flat_map(&:top).sort_by(&:wins)
  end
end
