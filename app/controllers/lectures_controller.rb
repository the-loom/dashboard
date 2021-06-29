class LecturesController < ApplicationController
  layout "application2", except: [:overview]

  before_action do
    check_feature(:lectures)
  end

  def index
    authorize Lecture
    @lectures = Lecture.all
  end

  def new
    authorize Lecture, :create?
    @lecture = Lecture.new
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

  def overview
    authorize Lecture
    @lectures = Lecture.all
    @students = Course.current.memberships.includes({ user: :memberships }).student.collect(&:user)
  end

  private
    def lecture_params
      params[:lecture].permit(:summary, :date, :required)
    end
end
