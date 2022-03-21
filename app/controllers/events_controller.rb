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
      flash[:success] = "Se creo correctamente el evento"
    else
      @labels = OpenStruct.new(title: "Nuevo evento", button: "Guardar evento")
      render :form
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

    if @event.update(event_params)
      redirect_to events_path
      flash[:success] = "Se actualizó correctamente el evento"
    else
      @labels = OpenStruct.new(title: "Editar evento", button: "Actualizar evento")
      render :form
    end
  end

  private
    def event_params
      params[:event].permit(:name, :description, :enabled,
                            :points, :min_points, :max_points,
                            :competence_tag_id)
    end
end
