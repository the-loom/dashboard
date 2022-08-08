# CESSI
Course.current = Course.find(53)

team_id_score = [
  [363, 4], [352, 6], [354, 1], [356, 9], [357, 0], [359, 0], [360, 8], [361, 0], [362, 6], [358, 10], [420, 6], [370, 2], [368, 7.5], [401, 0], [402, 8], [353, 3], [400, 6.5], [355, 9], [372, 9], [399, 8]
]

event = Event.find(493)

team_id_score.each do |datum|
  team_id = datum[0]
  score = datum[1]
  next if score == 0

  team = Team.unscoped.find(team_id)
  Course.current = team.course
  team.enabled_members.each do |student|
    student.register(event, score * 2)
  end
end
