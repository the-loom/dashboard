class CertificatesController < ApplicationController
  def index
    authorize Certificate, :use?
    @certificates = Certificate.where(user: current_user)
  end
end
