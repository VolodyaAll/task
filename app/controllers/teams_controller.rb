class TeamsController < ApplicationController
  add_breadcrumb "Tournaments", :root_path

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      redirect_to teams_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    redirect_to teams_path
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
