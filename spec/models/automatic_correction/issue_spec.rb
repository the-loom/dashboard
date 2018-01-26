require 'rails_helper'

RSpec.describe AutomaticCorrection::Issue, type: :model do
  it "has flexible payload" do
    issue1 = AutomaticCorrection::Issue.create(payload: {line: 1, severity: 'high'})
    issue2 = AutomaticCorrection::Issue.create(payload: {details: 'some detail'})

    expect(issue1.payload['line']).to eq(1)
    expect(issue2.payload['details']).to eq('some detail')
  end
end
