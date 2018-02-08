module CourseLock

	def self.included(base)
		base.class_eval do
			default_scope {
				if Course.current
					where(course_id: Course.current.id)
				else
					raise NoCourseAvailable
				end
			}
			# HELP: http://stackoverflow.com/questions/12667036/default-scope-ignoring-dynamic-value-in-condition/12667077#12667077
			belongs_to :course
			validates_presence_of :course

			before_save :verify_current_course
		end
	end

	def verify_current_course()
		if self.course != Course.current
			raise WrongCourseException
		end
	end
end

class WrongCourseException < Exception
end

class NoCourseAvailable < Exception
end
