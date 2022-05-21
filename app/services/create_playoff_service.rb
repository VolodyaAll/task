# frozen_string_literal: true

# Service for playoff creation
class CreatePlayoffService
  def initialize(tournament)
    @tournament = tournament
  end

  def call
    teams = tournament.teams_for_playoff_stage
    tournament.playoffs.create(name: 'Playoff', teams: teams)
    CreateDivisionGamesService.new(tournament.playoffs.last).for_playoff(teams)

    tournament.playoffs.last
  end

  private

  attr_reader :tournament
end
