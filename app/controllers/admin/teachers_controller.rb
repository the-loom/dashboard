module Admin
  class TeachersController < ApplicationController
    def index
      authorize :teacher, :index?
      @teachers = User.includes(:memberships).where(memberships: { course: Course.current, role: :teacher })
    end

    def destroy
      user = User.find(params[:id])
      authorize :teacher, :destroy?
      user.current_membership.discard

      redirect_to admin_teachers_path
    end

    def demote
      user = User.find(params[:id])
      authorize current_user, :promote?
      user.current_membership.update(role: :student)
      flash[:info] = "#{user.full_name} fue degradado a Estudiante"
      redirect_to admin_teachers_path
    end

    def join
      if !params[:teachers].present? || !params[:teachers][:ids].present?
        flash[:alert] = "Debes seleccionar al menos a un docente para unir perfiles"
        redirect_to(admin_teachers_path) && (return)
      end

      teachers = User.where(id: params[:teachers][:ids].map(&:to_i))
      authorize User, :join?
      if ProfileJoiner.new(teachers).execute
        flash[:success] = "Se unieron correctamente #{teachers.size} perfiles"
      end
      redirect_to admin_teachers_path
    end
  end
end
