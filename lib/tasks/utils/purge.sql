-- old courses
delete from courses where created_at < NOW() - interval '2 year' and enabled = false;
-- memberships without courses
delete from memberships where course_id not in (select distinct id from courses);
-- users with no memberships
delete from users where id not in (select distinct user_id from memberships);
-- users with no identities
delete from users where id not in (select distinct user_id from identities);
-- identities with no users
delete from identities where user_id not in (select distinct id from users);
-- memberships with no users
delete from memberships where user_id not in (select distinct id from users);

-- contar todo
-- SELECT schemaname,relname,n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;

-- occurrences for nonexisting courses or users
delete from events where course_id not in (select distinct id from courses);
delete from occurrences where course_id not in (select distinct id from courses) or user_id not in (select distinct id from users) or event_id not in (select distinct id from events);

-- orphan multiple choices and the chain
delete from multiple_choices_questionnaires where course_id not in (select distinct id from courses);
delete from multiple_choices_questions where multiple_choices_questionnaire_id not in (select distinct id from multiple_choices_questionnaires);
delete from multiple_choices_answers where multiple_choices_question_id not in (select distinct id from multiple_choices_questions);

-- user responses
delete from multiple_choices_solutions where multiple_choices_questionnaire_id not in (select distinct id from multiple_choices_questionnaires)
or user_id not in (select distinct id from users);
delete from multiple_choices_responses where multiple_choices_solution_id not in (select distinct id from multiple_choices_solutions);