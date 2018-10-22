class EventsController < ApplicationController
  before_action do
    check_feature(:events)
  end

  def index
    authorize Event
    @events = Event.all
  end

  def show
    authorize Event
    @event = Event.find(params[:id])
    @students = @event.users
    @occurrences = @event.occurrences
  end

  def new
    authorize Event, :create?
    @event = Event.new
    @labels = OpenStruct.new(title: "Nuevo evento", button: "Guardar evento")
    render :form
  end

  def create
    authorize Event, :create?
    @event = Event.new(event_params)

    if @event.valid?
      @event.save
      redirect_to events_path
      flash[:info] = "Se creo correctamente el evento"
    else
      render action: :new
    end
  end

  def edit
    authorize Event, :manage?
    @event = Event.find(params[:id])
    @labels = OpenStruct.new(title: "Editar evento", button: "Actualizar evento")
    render :form
  end

  def update
    authorize Event, :manage?
    @event = Event.find(params[:id])

    if @event.update_attributes(event_params)
      redirect_to events_path
      flash[:info] = "Se actualizó correctamente el evento"
    else
      render action: :edit
    end
  end

  private
    def event_params
      params[:event].permit(:name, :description, :batch_size, :points_per_batch)
    end
end
