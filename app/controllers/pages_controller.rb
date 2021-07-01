class PagesController < ApplicationController
  layout "application2"

  def root
    if current_user
      redirect_to dashboard_index_path
    else
      redirect_to welcome_path
    end
  end

  def welcome
    @title = "¡Bienvenido!"
  end
end
