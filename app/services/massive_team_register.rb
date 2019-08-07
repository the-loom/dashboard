class MassiveTeamRegister
  def initialize(students, team)
    @students = students
    @team = team
  end

  def execute
    @students.each do |student|
      @team.memberships << student.current_membership
    end

    true
  end
end
