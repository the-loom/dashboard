module HasDifficulty
  MAX = 5

  def self.included(base)
    base.class_eval do
      validates_presence_of :difficulty
      validates :difficulty, inclusion: { in: 1..5, message: "must be between 1 and 5" }

      scope :easy, -> { where(difficulty: 1) }
      scope :medium, -> { where(difficulty: [2, 3]) }
      scope :hard, -> { where(difficulty: [4, 5]) }
    end
  end
end
