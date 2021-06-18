class MultipleChoices::QuestionnairePolicy < ApplicationPolicy
  def monitor?
    user.teacher?
  end
  def manage?
    user.teacher? && Course.current.editable?
  end
  def access?
    user.student? || user.teacher?
  end
end
