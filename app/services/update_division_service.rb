class UpdateDivisionService
  def initialize(division_id, games_attributes)
    @division = Division.find(division_id)
    @games_attributes = games_attributes
  end

  def call
    division.update(games_attributes: games_attributes)
    division
  end

  private

  attr_reader :division, :games_attributes
end
