class GuestsController < ApplicationController
  def index
    authorize :guest, :index?
    @guests = User.includes(:memberships).where(memberships: { course: Course.current, role: :guest })
  end

  def destroy
    user = User.find(params[:id])
    authorize :guest, :destroy?
    user.current_membership.discard

    redirect_to guests_path
  end
end
