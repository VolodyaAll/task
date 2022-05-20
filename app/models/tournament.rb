class Tournament < ApplicationRecord
  TEAMS_COUNT = 16

  has_many :divisions, dependent: :destroy
  has_one :playoff, -> { where(name: 'Playoff') }, class_name: 'Division', dependent: :destroy
  has_one :winner, class_name: 'Team'
  has_and_belongs_to_many :teams


  validate :teams_conditions
  validates :name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w(draft in_progress done) }

  def teams_conditions
    if teams.uniq.length < TEAMS_COUNT
      errors.add(:teams, 'Only unique teams can participate in the tournament')
    end
  end

  def create_a_playoff?
    # binding.pry
    # playoffs.size < Math.log2(TEAMS_COUNT) - 1 && divisions.all?(&:all_games_played?)
    playoff.nil? && divisions.all?(&:all_games_played?)
  end
end
