class EventsController < ApplicationController

  def index
    authorize Event
    @events = Event.all
  end

  def show
    authorize Event
    @event = Event.find(params[:event_id])
    @students = User.student.sorted
  end

  def register
    authorize Event
    event = Event.find(params[:event_id])
    student = User.where(nickname: params[:nickname]).first if params[:nickname]
    student.register(event)
    flash[:info] = "Se asignó correctamente el evento #{event.name} a #{student.name}"
    redirect_to event_details_url(event.id)
  end
end
