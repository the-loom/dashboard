class CoursesController < ApplicationController
  layout "application2"

  def index
    @courses = Course.kept.enabled.registrable.order(name: :asc)
  end

  def enroll
    course = Course.find(params[:id])

    if course.password == params[:enrollment][:password]
      unless Membership.exists?(role: :student, course: course, user: current_user)
        current_user.memberships << Membership.create(role: :student, course: course)
      end
      session[:course_id] = course.id
      redirect_to profile_path
    else
      flash[:alert] = "La contraseña no es correcta. Pedísela a tus docentes por favor"
      redirect_to courses_path
    end
  end

  def switch
    course = Course.find(params[:id])
    course.switch(current_user, session)
    redirect_to root_path
  end
end
