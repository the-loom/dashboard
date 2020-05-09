require "rails_helper"

RSpec.describe PeerReview::Challenge, type: :model do
  describe "with teams challenge" do
    let(:course_with_teams) { create :course, features: Course.all_features[:teams] }
    let(:course_without_teams) { create :course }
    let(:team_graded_challenge) { create :graded_challenge, team_challenge: true, course: course_with_teams }

    it "is not valid unless teams are enabled for course" do
      team_graded_challenge.course = course_without_teams
      expect(team_graded_challenge).to_not be_valid

      team_graded_challenge.course = course_with_teams
      expect(team_graded_challenge).to be_valid
    end

    it "is valid for teachers" do
      expect(team_graded_challenge).to be_valid
    end

    it "is not valid for students" do
      team_graded_challenge.challenge_mode = :student_reviews_only
      expect(team_graded_challenge).to_not be_valid
    end

    it "is not valid for 360" do
      team_graded_challenge.challenge_mode = :student_and_teacher_reviews
      expect(team_graded_challenge).to_not be_valid
    end
  end

  describe "with quick reviews" do
    let(:graded_challenge) { create :graded_challenge }

    it "is valid for teachers" do
      expect(graded_challenge).to be_valid
    end

    it "is not valid for students" do
      graded_challenge.challenge_mode = :student_reviews_only
      expect(graded_challenge).to_not be_valid
    end

    it "is not valid for 360" do
      graded_challenge.challenge_mode = :student_and_teacher_reviews
      expect(graded_challenge).to_not be_valid
    end
  end
end
