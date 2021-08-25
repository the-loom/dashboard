module Admin
  class UsersController < ApplicationController
    layout "application2"

    def index
      authorize User, :impersonate?
      @users = User.includes([:memberships, avatar_attachment: :blob]).where(memberships: { course: Course.enabled })
      @title = "Usuarios activos"
    end

    def all
      authorize User, :impersonate?
      @users = User.all.includes([avatar_attachment: :blob])
      @title = "Todos los usuarios"
      render :index
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
