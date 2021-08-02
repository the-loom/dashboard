module CourseLock
  def self.included(base)
    base.class_eval do
      belongs_to :course

      return if ENV["RAILS_ENV"] == "test"
      default_scope {
        if Course.current.nil?
          raise NoCourseAvailable
        else
          if Course.current.replica && [Exercise, PeerReview::Challenge, MultipleChoices::Questionnaire, Resource, ResourceCategory, Event, Faq].include?(base)
            # replica and entity from parent
            where(course_id: Course.current.parent_course_id)
          elsif Course.current.replica && [Post].include?(base)
            # replica and entity from parent or myself
            where(course_id: [Course.current.id, Course.current.parent_course_id])
          elsif Course.current.replicas.size > 0 && ![Post, Exercise, MultipleChoices::Questionnaire, Faq, Resource, ResourceCategory, Event].include?(base)
            # parent and entity from me or replicas
            where(course_id: Course.current.family_ids)
          else
            # any other case
            where(course_id: Course.current.id)
          end
        end
      }
      # HELP: http://stackoverflow.com/questions/12667036/default-scope-ignoring-dynamic-value-in-condition/12667077#12667077
      validates_presence_of :course

      before_save :verify_current_course
    end
  end

  def verify_current_course
    raise WrongCourseException unless self.course == Course.current || User.current && User.current.admin?
  end
end

class WrongCourseException < Exception
end

class NoCourseAvailable < Exception
end
