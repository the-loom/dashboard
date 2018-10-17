module DifficultyHelper
  def difficulty(value, max = 5)
    render partial: "shared/difficulty", locals: { value: value, max: max }
  end
end
