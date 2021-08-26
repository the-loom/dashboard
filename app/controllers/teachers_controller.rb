class TeachersController < ApplicationController
  layout "application5"

  def index
    authorize :teacher, :show?
    @teachers = Course.current.teachers.order(last_name: :asc)
  end
end
