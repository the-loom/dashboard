class SolutionPolicy < ApplicationPolicy
  def show?
    is_own_solution(record, user)
  end

  def start?
    is_own_solution(record, user)
  end

  def finish?
    is_own_solution(record, user)
  end

  def cancel?
    is_own_solution(record, user)
  end

  def timer?
    is_own_solution(record, user)
  end

  private
  def is_own_solution(solution, user)
    solution.user == user
  end

end
