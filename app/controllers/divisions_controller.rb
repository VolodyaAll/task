class DivisionsController < ApplicationController
  def edit
    add_breadcrumb "Teams", :teams_path
    add_breadcrumb "Tournaments", :tournaments_path
    @division = Division.find(params[:tournament_id])
    tournament = @division.tournament
    add_breadcrumb "Tournament #{tournament.name}", tournament_path(tournament)
  end

  def update
    @division = UpdateDivisionService.new(params[:id], division_params[:games_attributes]).call

    if @division.valid?
      redirect_to tournament_path(@division.tournament)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def division_params
    params.require(:division).permit(games_attributes: [:id, :winner_id])
  end
end
