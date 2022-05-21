# frozen_string_literal: true

# Controller class for divisions handling
class DivisionsController < ApplicationController
  def edit
    add_breadcrumb 'Teams', :teams_path
    add_breadcrumb 'Tournaments', :tournaments_path
    @division = Division.find(params[:id])
    tournament = @division.tournament
    add_breadcrumb "Tournament #{tournament.name}", tournament_path(tournament)
    @winners = @division.top(@division.teams.size)
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
    params.require(:division).permit(games_attributes: %i[id winner_id])
  end
end
