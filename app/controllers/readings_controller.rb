class ReadingsController < ApplicationController

  def index
    authorize Reading
    @readings = Reading.all
  end

  def show
    authorize Reading
    @reading = Reading.where(slug: params[:slug]).first
    @teams = Team.sorted
  end

  def register
    authorize Reading
    measurement = Measurement.create(measurement_params)
    flash[:info] = "Se guardó correctamente la medición #{measurement.reading.name} a #{measurement.team.name}"
    redirect_to reading_details_url(measurement.reading.slug)
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
