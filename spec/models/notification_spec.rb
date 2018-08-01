require "rails_helper"

RSpec.describe Notification, type: :model do
  it {
    should validate_presence_of(:subject)
    should validate_presence_of(:text)
    should validate_presence_of(:author)
  }
end
