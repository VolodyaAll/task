# frozen_string_literal: true

# Service for tournament creation
class CreateTournamentService
  def initialize(name, team_ids)
    @name = name
    @team_ids = team_ids
  end

  def call
    @tournament = Tournament.create(name: name, team_ids: team_ids)
    create_divisions if @tournament.valid?
    tournament
  end

  private

  attr_reader :name, :team_ids, :tournament

  def create_divisions
    team_a_ids, team_b_ids = team_ids.shuffle.in_groups_of(Tournament::TEAMS_COUNT / 2)

    create_division('A', team_a_ids)
    create_division('B', team_b_ids)
  end

  def create_division(name, team_ids)
    tournament.divisions.create(name: name, team_ids: team_ids).tap do |division|
      CreateDivisionGamesService.new(division).for_division
    end
  end
end
