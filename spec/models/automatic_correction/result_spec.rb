require "rails_helper"

RSpec.describe AutomaticCorrection::Result, type: :model do
  it "has test_type enum field" do
    result = AutomaticCorrection::Result.create(
      test_type: :junit
                           )
    expect(result.test_type).to eq(:junit.to_s)
  end
end
