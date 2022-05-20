class Team < ApplicationRecord
  # has_many :games
  # has_and_belongs_to_many :divisions
  # has_and_belongs_to_many :tournaments

  validates :name, presence: true, uniqueness: true
end
