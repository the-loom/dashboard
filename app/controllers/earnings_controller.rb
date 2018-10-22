class EarningsController < ApplicationController
  def destroy
    authorize Badge, :register?
    earning = Earning.find(params[:id])
    badge = earning.badge

    earning.delete
    redirect_to badge_path(badge)
  end
end
