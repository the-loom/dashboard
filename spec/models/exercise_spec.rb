require "rails_helper"

RSpec.describe Exercise, type: :model do
  it {
    should validate_presence_of(:name)
    should validate_presence_of(:url)
  }

  it {
    module CourseLock
      def verify_current_course; end
    end
    should validate_uniqueness_of(:name)
               .scoped_to(:course_id)
  }
end
