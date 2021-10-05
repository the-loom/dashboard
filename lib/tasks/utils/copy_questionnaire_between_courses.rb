source_course = Course.find(52)
destination_id = Course.find(34)
Course.current = source_course
User.current = User.find(1)

MultipleChoices::Questionnaire.unscoped.where(course: source_course, id: 94).each do |questionnaire|
  new_questionnaire = questionnaire.dup
  new_questionnaire.course = destination_id

  questionnaire.questions.unscoped.where(multiple_choices_questionnaire_id: questionnaire.id).each do |question|
    new_question = question.dup
    question.answers.unscoped.where(multiple_choices_question_id: question.id).each do |answer|
      new_question.answers << answer.dup
    end
    new_questionnaire.questions << new_question
  end

  new_questionnaire.enabled = true
  new_questionnaire.published = false
  new_questionnaire.save!
end
