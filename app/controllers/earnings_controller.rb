class EarningsController < ApplicationController
  def destroy
    authorize Badge, :register?
    earning = Earning.find(params[:id])
    badge = earning.badge

    earning.delete
    redirect_to badge_path(badge)
  end

  private
    def badge_params
      params[:badge].permit(:name, :description, :slug, :featured)
    end
end
