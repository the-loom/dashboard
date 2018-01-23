require "rails_helper"

RSpec.describe Event, type: :model do
  it "is assigned correctly" do
    user = User.create!(name: 'John', points: 0)
    event = Event.create!(name: 'Attendance', batch_size: 5, points_per_batch: 10)

    user.register(event)

    expect(user.events).to include(event)
  end

  it "computes points after batch_size has been achieved" do
    user = User.create!(name: 'John', points: 0)
    event = Event.create!(name: 'Attendance', batch_size: 5, points_per_batch: 10)

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
