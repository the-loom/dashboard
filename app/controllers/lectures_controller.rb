class LecturesController < ApplicationController
  def index
    authorize Lecture
    @lectures = Lecture.all
  end

  def summary
    authorize Lecture
    @lectures = Lecture.all
    @attendances = Attendance.all
    @attendances_per_student = @attendances.group_by { |a| a.user }
    @students = @attendances_per_student.keys
  end

  def show
    authorize Lecture
    @lecture = Lecture.find(params[:lecture_id])
    @students = User.student.sorted_by_name
  end

  def register
    authorize Lecture
    lecture = Lecture.find(params[:lecture_id])

    params[:student_ids].each do |student_id, condition|
      student = User.find(student_id)
      student.unregister_attendance(lecture)
      student.register_attendance(lecture, condition.to_i == 1 ? :present : :absent)
    end

    flash[:notice] = "Se registró la asistencia correctamente"
    redirect_to lectures_list_url
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
