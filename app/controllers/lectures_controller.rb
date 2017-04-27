class LecturesController < ApplicationController

  def index
    authorize Lecture
    @lectures = Lecture.all
  end

  def show
    authorize Lecture
    @lecture = Lecture.find(params[:lecture_id])
    @students = User.student.sorted
  end

  def register
    authorize Lecture
    5/0

    # 1. des-registrar todas las asistencias a esa clase
    # 2. registrar asistencias a la clase

    redirect_to lecture_details_url(check.lecture.id)
  end

  def new
    authorize Lecture, :create?
    @lecture = Lecture.new
  end

  def create
    authorize Lecture, :create?
    @lecture = Lecture.new(lecture_params)
    if @lecture.save
      flash[:notice] = "Se creo correctamente la clase"
    end
    redirect_to lectures_list_url
  end

  private
  def lecture_params
    params[:lecture].permit(:summary, :date)
  end
end
