module Admin
  class UsersController < ApplicationController
    def index
      authorize User, :impersonate?
      @users = User.all.includes([:memberships, avatar_attachment: :blob, memberships: :course])
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

    def impersonate
      @user = User.find(params[:id])
      authorize @user, :impersonate?
      login_user(@user)
    end
  end
end
