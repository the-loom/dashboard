FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    password { "password" }
  end

  factory :peer_review_challenge, class: PeerReview::Challenge do
    sequence(:title) { |n| "Challenge #{n}" }
    instructions { "Some instructions" }
    reviewer_instructions { "More instructions, for reviewer" }
    allows_quick_reviews { false }

    course

    trait :teacher_reviews do
      challenge_mode { :teacher_reviews_only }
    end

    trait :student_reviews do
      challenge_mode { :student_reviews_only }
    end

    trait :quick_reviews do
      allows_quick_reviews { true }
    end

    factory :graded_challenge, traits: [:teacher_reviews, :quick_reviews]
  end
end
