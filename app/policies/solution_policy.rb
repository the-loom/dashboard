class SolutionPolicy < ApplicationPolicy
  def show?
    is_own_solution(record, user)
  end

  def summary?
    is_own_solution(record, user) || user.teacher?
  end

  def start?
    is_own_solution(record, user)
  end

  def add_partner?
    is_own_solution(record, user)
  end

  def finish?
    is_own_solution(record, user)
  end

  def cancel?
    is_own_solution(record, user) || user.teacher?
  end

  def timer?
    is_own_solution(record, user)
  end

  private
  def is_own_solution(solution, user)
    solution.users.include? user
  end

end
