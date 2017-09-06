class PartnersController < ApplicationController

  def index
    render json: User.student.collect(&:nickname)
  end

end
