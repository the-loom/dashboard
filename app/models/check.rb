class Check < ApplicationRecord
  include CourseLock

  enum condition: {
      bad: -1,
      missing: 0,
      good: 1
  }

  belongs_to :team
  belongs_to :checkpoint

  default_scope { order(created_at: :asc) }

  # TODO(delucas): move to presenter
  def css_label
    "label-info" if missing?
    "label-danger" if bad?
    "label-success" if good?
  end
end
