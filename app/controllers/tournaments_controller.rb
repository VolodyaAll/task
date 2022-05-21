# frozen_string_literal: true

# Controller class for tournaments handling
class TournamentsController < ApplicationController
  add_breadcrumb 'Teams', :teams_path
  add_breadcrumb 'Tournaments', :root_path

  def index
    @tournaments = Tournament.all
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def new
    @tournament = Tournament.new
    @teams = Team.all
  end

  def create
    @tournament = CreateTournamentService.new(tournament_params[:name], tournament_params[:team_ids]).call
    @teams = Team.all

    if @tournament.valid?
      redirect_to @tournament
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_playoff
    @tournament = Tournament.find(params[:id])
    @playoff = CreatePlayoffService.new(@tournament).call

    if @playoff.valid?
      redirect_to @tournament
    else
      flash[:message] = 'Not all games in divisions are played'
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    redirect_to tournaments_path
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, team_ids: [])
  end
end
