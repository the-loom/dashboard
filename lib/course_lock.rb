module CourseLock
  def self.included(base)
    base.class_eval do
      belongs_to :course

      return if ENV["RAILS_ENV"] == "test"
      default_scope {
        if Course.current.nil?
          raise NoCourseAvailable
        else
          where(course_id: Course.current.id)
        end
      }
      # HELP: http://stackoverflow.com/questions/12667036/default-scope-ignoring-dynamic-value-in-condition/12667077#12667077
      validates_presence_of :course

      before_save :verify_current_course
    end
  end

  def verify_current_course
    raise WrongCourseException unless self.course == Course.current || User.current.admin?
  end
end

class WrongCourseException < Exception
end

class NoCourseAvailable < Exception
end
