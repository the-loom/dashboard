class CertificatePolicy < ApplicationPolicy
  def use?
    user.teacher? || user.student?
  end
end
