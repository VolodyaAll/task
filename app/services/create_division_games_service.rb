class CreateDivisionGamesService
  def initialize(division)
    @division = division
  end

  def call
    division.teams.to_a.combination(2).each do |team_one, team_two|
      division.games.create(team_one: team_one, team_two: team_two)
    end
  end

  private

  attr_reader :division
end
