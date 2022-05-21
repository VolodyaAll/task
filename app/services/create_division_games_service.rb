# frozen_string_literal: true

# Service for games creation
class CreateDivisionGamesService
  def initialize(division)
    @division = division
  end

  def for_division
    division.teams.to_a.combination(2).each do |team_one, team_two|
      division.games.create(team_one: team_one, team_two: team_two)
    end
  end

  def for_playoff(teams)
    worst_teams, best_teams = teams.in_groups_of(teams.size / 2)
    best_teams.zip(worst_teams.reverse).each do |best_team, worst_team|
      division.games.create(team_one: best_team, team_two: worst_team)
    end
  end

  private

  attr_reader :division
end
