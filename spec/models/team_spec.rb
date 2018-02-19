require "rails_helper"

RSpec.describe Team, type: :model do
  it {
    should validate_presence_of(:name)
    should validate_presence_of(:nickname)
    should validate_presence_of(:image)
  }

  it {

    module CourseLock
      def verify_current_course; end
    end

    should validate_uniqueness_of(:name)
               .scoped_to(:course_id)

    should validate_uniqueness_of(:nickname)
               .scoped_to(:course_id)
  }

end
