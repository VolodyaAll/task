# frozen_string_literal: true

# Division update service
class UpdateDivisionService
  def initialize(division_id, games_attributes)
    @division = Division.find(division_id)
    @games_attributes = games_attributes
    @tournament = @division.tournament
  end

  def call
    division.update(games_attributes: games_attributes)
    change_tournament_state
    division
  end

  private

  attr_reader :division, :games_attributes

  def change_tournament_state
    finalist = division.games.first.looser
    winner = division.games.first.winner
    tournament = @division.tournament

    division.final_playoff_stage? ? tournament.finish(finalist, winner) : tournament.start
  end
end
