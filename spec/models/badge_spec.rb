require "rails_helper"

RSpec.describe Badge, type: :model do
  it {
    should validate_presence_of(:name)
    should validate_presence_of(:description)
  }

  it {
    module CourseLock
      def verify_current_course; end
    end
    should validate_uniqueness_of(:name)
               .scoped_to(:course_id)
  }

  it "is assigned correctly" do
    user = User.create!(first_name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    badge = Badge.create!(name: "Neat", description: "Some description", course: Course.current)

    user.earn(badge)

    expect(user.badges).to include(badge)
  end
end
