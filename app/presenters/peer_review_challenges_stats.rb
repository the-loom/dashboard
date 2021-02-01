class PeerReviewChallengesStats
  def initialize(students, challenges)
    @students = students
    @challenges = challenges
  end

  def solutions_to_challenges
    @solutions = Hash.new { [] }
    @students.each do |student|
      @solutions[student] = @challenges.map { |challenge| challenge.solved(student) }
    end
    @solutions
  end

  def challenges_made_by(student)
    @solutions[student].count(true)
  end

  def percentage_of_solutions_made_by(student)
    (@solutions[student].count(true).to_d * 100 / @solutions[student].size).round(2)
  end

  def number_of_challenges_solved
    number_of_solutions_challenges = []
    @challenges.each_with_index do |_, index|
      number_of_solutions = 0
      @solutions.each do |_, challenge|
        number_of_solutions += 1 if challenge[index]
      end
      number_of_solutions_challenges << number_of_solutions
    end
    number_of_solutions_challenges
  end
end
