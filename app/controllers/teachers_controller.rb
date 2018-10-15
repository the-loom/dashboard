class TeachersController < ApplicationController
  def index
    authorize :teacher, :index?
    @teachers = User.includes(:memberships).where(memberships: { course: Course.current, role: :teacher })
  end

  def destroy
    user = User.find(params[:id])
    authorize :teacher, :destroy?
    user.current_membership.discard

    redirect_to teachers_path
  end
end
