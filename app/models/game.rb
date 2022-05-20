class Game < ApplicationRecord
  belongs_to :division
  belongs_to :team_one, class_name: 'Team'
  belongs_to :team_two, class_name: 'Team'
  belongs_to :winner, class_name: 'Team', optional: true

  validates :team_one, :team_two, :division, presence: true
end
