module DifficultyHelper
  def stars_for(has_difficulty, max = HasDifficulty::MAX)
    render partial: "shared/difficulty", locals: { value: has_difficulty.difficulty, max: max }
  end
end
