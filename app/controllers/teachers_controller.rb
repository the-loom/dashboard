class TeachersController < ApplicationController
  layout "application2", only: [:index]

  def index
    authorize :teacher, :show?
    @teachers = Course.current.teachers.order(last_name: :asc)
  end
end
