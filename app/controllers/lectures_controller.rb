class LecturesController < ApplicationController
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
  end

  def create
    authorize Lecture, :create?
    @lecture = Lecture.new(lecture_params)
    if @lecture.save
      flash[:info] = "Se creo correctamente la clase"
    end
    redirect_to lectures_path
  end

  def summary
    authorize Lecture
    @lectures = Lecture.all
    @attendances = Attendance.all
    @attendances_per_student = @attendances.group_by { |a| a.user }
    @students = Course.current.memberships.student.collect(&:user)
  end

  private
    def lecture_params
      params[:lecture].permit(:summary, :date)
    end
end
