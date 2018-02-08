class PartnersController < ApplicationController
  def index
    render json: Membership.student.collect { |x| x.user.nickname }
  end
end
