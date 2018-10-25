class GuestsController < ApplicationController
  def index
    authorize :guest, :index?
    @guests = User.includes(:memberships).where(memberships: { course: Course.current, role: :guest })
  end

  def bulk_edit
    if !params[:guests].present? || !params[:guests][:ids].present?
      flash[:info] = "Debes seleccionar al menos a un aspirante para cambiar su rol"
      redirect_to guests_path
      return
    end

    guest_ids = params[:guests][:ids].map(&:to_i)

    if params[:bulk_edit][:action].present?
      guests = User.where(id: guest_ids)

      if params[:bulk_edit][:action] == "mark_as"
        Course.current.memberships.where("user_id IN (?)", guest_ids).update_all(role: params[:bulk_edit][:auxiliary_id].to_sym)
        flash[:info] = "Se cambió el rol a #{guests.size} aspirantes"
      end

      redirect_to guests_url
      return
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize :guest, :destroy?
    user.current_membership.discard

    redirect_to guests_path
  end
end
