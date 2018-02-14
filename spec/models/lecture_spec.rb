require "rails_helper"

RSpec.describe Lecture, type: :model do
  it "is assigned correctly" do
    Course.current = Course.new(name: "STEM I")
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), course: Course.current)

    user.register_attendance(lecture, :present)

    expect(user.lectures).to include(lecture)
  end
  it "earns points when present" do
    Course.current = Course.new(name: "STEM I")
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), course: Course.current)

    user.register_attendance(lecture, :present)

    expect(user.points).to eq(10)
  end
  it "doesn't earn points when absent" do
    Course.current = Course.new(name: "STEM I")
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), course: Course.current)

    user.register_attendance(lecture, :absent)

    expect(user.points).to eq(0)
  end
  it "can un-register assistance" do
    Course.current = Course.new(name: "STEM I")
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22), course: Course.current)
    user.register_attendance(lecture, :present)
    expect(user.points).to eq(10)
    expect(user.lectures).to include(lecture)

    user.unregister_attendance(lecture)
    expect(user.points).to eq(0)
    expect(user.lectures).to_not include(lecture)
  end
end
