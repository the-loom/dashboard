class CoursesController < ApplicationController
  def index
    @courses = Course.kept.enabled
  end

  def enroll
    course = Course.find(params[:id])
    current_user.memberships << Membership.create(role: :guest, course: course, points: 0)
    session[:course_id] = course.id
    redirect_to profile_path
  end

  def switch
    course = Course.find(params[:id])
    session[:course_id] = course.id
    redirect_to profile_path
  end
end
