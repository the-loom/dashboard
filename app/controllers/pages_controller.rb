class PagesController < ApplicationController
  layout "application2"

  def welcome
    @title = "¡Bienvenido!"
  end
end
