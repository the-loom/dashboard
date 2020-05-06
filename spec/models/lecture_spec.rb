require "rails_helper"

RSpec.describe Lecture, type: :model do
  it {
    should validate_presence_of(:date)
    should validate_presence_of(:summary)
  }

  it {
    module CourseLock
      def verify_current_course; end
    end
    should validate_uniqueness_of(:summary)
               .scoped_to(:course_id)
  }

  xit "is assigned correctly" do
    user = User.create!(first_name: "John")

    event = Event.create!(course: Course.current, name: "Attendance", description: "Some description", points: 10, min_points: 10, max_points: 10)
    Course.current.attendance_event = event
    Course.current.save

    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), summary: "TDD", course: Course.current)

    user.register_attendance(lecture, :present)

    expect(user.lectures).to include(lecture)
  end

  xit "earns points when present" do
    user = User.create!(first_name: "John")

    event = Event.create!(course: Course.current, name: "Attendance", description: "Some description", points: 10, min_points: 10, max_points: 10)
    Course.current.attendance_event = event
    Course.current.save

    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), summary: "TDD", course: Course.current)

    user.register_attendance(lecture, :present)

    expect(user.points).to eq(10)
  end

  xit "doesn't earn points when absent" do
    user = User.create!(first_name: "John")

    event = Event.create!(course: Course.current, name: "Attendance", description: "Some description", points: 10, min_points: 10, max_points: 10)
    Course.current.attendance_event = event
    Course.current.save

    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), summary: "TDD", course: Course.current)

    user.register_attendance(lecture, :absent)

    expect(user.points).to eq(0)
  end
end
