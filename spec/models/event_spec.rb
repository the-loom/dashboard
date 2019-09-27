require "rails_helper"

RSpec.describe Event, type: :model do
  it {
    should validate_presence_of(:name)
    should validate_presence_of(:description)
    should validate_presence_of(:points)
    should validate_presence_of(:min_points)
    should validate_presence_of(:max_points)
  }

  it {
    module CourseLock
      def verify_current_course
      end
    end
    should validate_uniqueness_of(:name)
               .ignoring_case_sensitivity
               .scoped_to(:course_id)
  }

  it "is assigned correctly" do
    user = User.create!(first_name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    event = Event.create!(name: "Attendance", description: "Some description", points: 10, min_points: 10, max_points: 10)

    user.register(event)

    expect(user.events).to include(event)
    expect(user.points).to eq(10)
  end
end
