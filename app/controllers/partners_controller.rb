class PartnersController < ApplicationController
  def index
    render json: Course.current.memberships.student.collect { |x| x.user.nickname }
  end
end
