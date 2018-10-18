module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all
    end

    def edit
      5 / 0
=begin
      authorize Course, :admin?
      @course = Course.find(params[:id])
      @labels = OpenStruct.new(title: "Editar curso", button: "Actualizar curso")
      render :form
=end
    end

    def update
      5 / 0
=begin
      authorize Course, :admin?
      @course = Course.find(params[:id])

      if @course.update_attributes(course_params)
        redirect_to admin_courses_path
        flash[:info] = "Se editó correctamente el curso"
      else
        render action: :edit
      end
=end
    end

    def destroy
      course = Course.find(params[:id])
      authorize course, :admin?
      course.discard

      redirect_to admin_courses_path
    end

    def restore
      course = Course.find(params[:id])
      authorize course, :admin?
      course.undiscard

      redirect_to admin_courses_path
    end

    def impersonate
      @user = User.find(params[:id])
      authorize @user, :impersonate?
      session[:user_id] = @user.id
      redirect_to profile_url
    end
  end
end
