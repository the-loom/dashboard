class SolutionFinder
  def initialize(challenge, user)
    @challenge = challenge
    @user = user
  end

  def find_solution
    # 1. if myself only, as usual
    unless @challenge.team_challenge
      return PeerReview::Solution.find_or_initialize_by(challenge: @challenge, author: @user)
    end

    # 2. if teams, lookup for team's solution
    if @challenge.team_challenge
      return OpenStruct.new(new_record?: true) unless @user.current_membership.team
      challenge = PeerReview::Solution.find_by(challenge: @challenge, author: @user.current_membership.team.members)
    end
    # 3. if none, create new
    challenge ||= PeerReview::Solution.new(challenge: @challenge, author: @user)
    challenge
  end
end
