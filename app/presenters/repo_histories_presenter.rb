class RepoHistoriesPresenter

  attr_reader :summaries

  def initialize(repo)
    @summaries = Hash.new
    repo.forks.each do |fork|
      @summaries[fork.author.nickname] = fork.test_runs.where("score > 0").map do |tr|
        tr.score
      end
    end
  end

  def empty?
    @summaries.empty?
  end
end
