class LecturesController < ApplicationController
  include Extensions::Discarder.new(Lecture)

  before_action do
    check_feature(:lectures)
  end

  def index
    authorize Lecture
    @lectures = Lecture.kept
  end

  def new
    authorize Lecture, :create?
    latest_lecture = Lecture.order(id: :asc).last || NullLecture.new
    @lecture = Lecture.new(time_from: latest_lecture.time_from, time_to: latest_lecture.time_to)
    @labels = OpenStruct.new(title: "Nueva clase", button: "Guardar clase")
    render :form
  end

  def create
    authorize Lecture, :create?
    @lecture = Lecture.new(lecture_params)

    if @lecture.valid?
      @lecture.save
      redirect_to lectures_path
      flash[:success] = "Se creo correctamente la clase"
    else
      @labels = OpenStruct.new(title: "Nueva clase", button: "Guardar clase")
      render :form
    end
  end

  def edit
    authorize Lecture, :manage?
    @lecture = Lecture.find(params[:id])
    @labels = OpenStruct.new(title: "Editar clase", button: "Actualizar clase")
    render :form
  end

  def update
    authorize Lecture, :manage?
    @lecture = Lecture.find(params[:id])

    if @lecture.update_attributes(lecture_params)
      redirect_to lectures_path
      flash[:success] = "Se actualizó correctamente la clase"
    else
      @labels = OpenStruct.new(title: "Editar clase", button: "Actualizar clase")
      render :form
    end
  end

  def register_attendance
    authorize Lecture, :self_register?
    lecture = Lecture.find(params[:id])
    if lecture.current? && !current_user.present_at(lecture)
      current_user.register_attendance(lecture)
    end
    redirect_to root_path
  end

  def overview
    authorize Lecture
    @lectures = Lecture.past_and_current
    @students = Course.current.memberships.includes({ user: :memberships }).student.collect(&:user).compact
  end

  private
    def lecture_params
      params[:lecture].permit(:summary, :date, :time_from, :time_to, :required)
    end
end
