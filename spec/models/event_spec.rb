require "rails_helper"

RSpec.describe Event, type: :model do

  it {
    should validate_presence_of(:name)
    should validate_presence_of(:description)
    should validate_presence_of(:batch_size)
    should validate_presence_of(:points_per_batch)
  }

  it {

    module CourseLock
      def verify_current_course; end
    end
    should validate_uniqueness_of(:name)
               .scoped_to(:course_id)
  }

  xit "is assigned correctly" do
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    event = Event.create!(name: "Attendance", description: "Some description", batch_size: 5, points_per_batch: 10)

    user.register(event)

    expect(user.events).to include(event)
  end

  xit "computes points after batch_size has been achieved" do
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    event = Event.create!(name: "Attendance", description: "Some description", batch_size: 5, points_per_batch: 10)

    expect(user.points).to eq(0)
    user.register(event)
    user.register(event)
    user.register(event)
    user.register(event)
    expect(user.points).to eq(0)
    expect(user.events.size).to eq(4)
    user.register(event)
    expect(user.points).to eq(10)
  end
end
