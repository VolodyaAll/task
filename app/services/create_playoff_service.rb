class CreatePlayoffService
  def initialize(tournament)
    @tournament = tournament
  end

  def call
    playoff_teams = divisions_winners

    tournament.create_playoff(name: 'Playoff', teams: playoff_teams)
    worst_teams, best_teams = playoff_teams.in_groups_of(4)

    best_teams.zip(worst_teams.reverse).each do |best_team, worst_team|
      tournament.playoff.games.create(team_one: best_team, team_two: worst_team)
    end
    tournament.playoff
  end

  private

  attr_reader :tournament

  def top_4_winners(division)
    Team.select('teams.id, teams.name, count(*) AS wins')
        .joins('JOIN games ON teams.id = games.winner_id')
        .where(games: { division_id: division.id })
        .group(:id)
        .order('wins DESC')
        .limit(4)
  end

  def divisions_winners
    tournament.divisions.flat_map do |division|
      top_4_winners(division)
    end.sort_by(&:wins)
  end
end
