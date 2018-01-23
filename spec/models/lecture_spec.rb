require "rails_helper"

RSpec.describe Lecture, type: :model do
  it "is assigned correctly" do
    user = User.create!(name: 'John', points: 0)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22))

    user.register_attendance(lecture, :present)

    expect(user.lectures).to include(lecture)
  end
  it "earns points when present" do
    user = User.create!(name: 'John', points: 0)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22))

    user.register_attendance(lecture, :present)

    expect(user.points).to eq(10)
  end
  it "doesn't earn points when absent" do
    user = User.create!(name: 'John', points: 0)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22))

    user.register_attendance(lecture, :absent)

    expect(user.points).to eq(0)
  end
  it "can un-register assistance" do
    user = User.create!(name: 'John', points: 0)
    lecture = Lecture.create!(date: Date.new(2017, 4, 22))
    user.register_attendance(lecture, :present)
    expect(user.points).to eq(10)
    expect(user.lectures).to include(lecture)

    user.unregister_attendance(lecture)
    expect(user.points).to eq(0)
    expect(user.lectures).to_not include(lecture)
  end
end
