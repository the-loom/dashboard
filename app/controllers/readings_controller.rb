class ReadingsController < ApplicationController

  def index
    authorize Reading
    @readings = Reading.all
  end

  def prepare
    authorize Reading, :register?
    @readings = Reading.all
    @teams = Team.sorted
  end

  def register
    authorize Reading
    team = Team.find(params[:team_id].to_i)
    params[:value].each do |k, v|
      reading = Reading.find(k.to_i)
      Measurement.create(team: team, reading: reading, value: v.to_i) unless v.blank?
    end
    flash[:info] = "Se guardaron correctamente las mediciones para el equipo #{team.name}"
    redirect_to readings_list_url
  end

  def new
    authorize Reading, :create?
    @reading = Reading.new
  end

  def create
    authorize Reading, :create?
    @reading = Reading.new(reading_params)
    if @reading.save
      flash[:notice] = "Se creo correctamente la medición"
    end
    redirect_to readings_list_url
  end

  private
  def reading_params
    params[:reading].permit(:name, :description, :slug)
  end
  def measurement_params
    params[:measurement].permit(:team_id, :reading_id, :value)
  end
end
