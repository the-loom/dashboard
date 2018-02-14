require "rails_helper"

RSpec.describe Badge, type: :model do
  it "is assigned correctly" do
    Course.current = Course.new(name: "STEM I")
    user = User.create!(name: "John")
    user.memberships << Membership.new(course: Course.current, role: :student)
    badge = Badge.create!(name: "Neat", course: Course.current)

    user.earn(badge)

    expect(user.badges).to include(badge)
  end
end
