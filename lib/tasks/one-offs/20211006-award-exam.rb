# AP
Course.current = Course.find(34)

solutions = MultipleChoices::Solution.where(multiple_choices_questionnaire_id: 190)
event = Event.find(491)

solutions.each do |solution|
  Course.current = solution.course
  times = solution.responses.where(correct: true).count
  solution.solver.register(event, times, solution.course)
end


# CESSI
Course.current = Course.find(53)

solutions = MultipleChoices::Solution.where(multiple_choices_questionnaire_id: 191)
event = Event.find(494)

solutions.each do |solution|
  Course.current = solution.course
  times = solution.responses.where(correct: true).count
  solution.solver.register(event, times, solution.course)
end
