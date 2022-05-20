class TournamentsController < ApplicationController
  add_breadcrumb "Teams", :teams_path

  def index
    @tournaments = Tournament.all
  end

  def show
    add_breadcrumb "Tournaments", :root_path
    @tournament = Tournament.find(params[:id])
  end

  def new
    add_breadcrumb "Tournaments", :root_path
    @tournament = Tournament.new
  end

  def create
    @tournament = CreateTournamentService.new(tournament_params[:name], tournament_params[:team_ids]).call

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
      redirect_to @tournament
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    redirect_to tournaments_path
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, team_ids: [] )
  end
end
