require "rails_helper"

RSpec.describe Badge, type: :model do
  it "is assigned correctly" do
    user = User.create!(name: "John", points: 0)
    badge = Badge.create!(name: "Neat")

    user.earn(badge)

    expect(user.badges).to include(badge)
  end
end
