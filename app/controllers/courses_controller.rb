class CoursesController < ApplicationController

  def index
    @courses = Course.all
  end

  def enroll
    course = Course.find(params[:id])
    current_user.memberships << Membership.create(role: :guest, course: course)
    session[:course_id] = course.id
    redirect_to profile_path
  end

  def switch
    course = Course.find(params[:id])
    session[:course_id] = course.id
    redirect_to profile_path
  end

end
