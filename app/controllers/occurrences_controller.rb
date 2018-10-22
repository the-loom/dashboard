class OccurrencesController < ApplicationController
  def destroy
    authorize Event, :register?
    occurrence = Occurrence.find(params[:id])
    event = occurrence.event

    occurrence.delete
    redirect_to event_path(event)
  end
end
