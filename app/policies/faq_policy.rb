class FaqPolicy < ApplicationPolicy
  def manage?
    user.teacher? && Course.current.editable?
  end

  def use?
    user.teacher? || user.student?
  end
end
