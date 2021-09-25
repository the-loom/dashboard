class TeachersController < ApplicationController
  def index
    authorize :teacher, :show?
    @teachers = Course.current.teachers.order(last_name: :asc)
  end
end
