class PeerReviewChallengesStats
  def initialize(students, challenges)
    @students = students
    @challenges = challenges
  end

  def solutions_to_challenges
    @solutions = Hash.new { [] }
    @students.each do |student|
      @solutions[student] = @challenges.map { |challenge| resolved_at(student, challenge) }
    end
    @solutions
  end

  def challenges_made_by(student)
    "#{@solutions[student].count(true)}/#{@solutions[student].size}"
  end

  def percentage_of_solutions_made_by(student)
    (@solutions[student].count(true).to_d * 100 / @solutions[student].size).round(2)
  end

  def number_of_challenges_solved
    number_of_solutions_challenges=[]
    @challenges.each_with_index do |challenge, index|
      number_of_solutions = 0
      @solutions.each do |student, challenge|
        number_of_solutions += 1 if challenge[index]
      end
      number_of_solutions_challenges << number_of_solutions
    end
    number_of_solutions_challenges
  end

private
  def resolved_at(student, challenge)
    challenge.already_solved_by?(student) ||
    (challenge.team_challenge &&
    challenge.already_solved_by_team?(student.current_membership.team))
  end
end
