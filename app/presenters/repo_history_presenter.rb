class RepoHistoryPresenter

  attr_reader :summary

  def initialize(repo)
    @repo = repo

    @test_runs = repo.test_runs.order(updated_at: :asc)
    return if @test_runs.empty?

    @summary = Hash.new
    @test_runs.first.results.each do |result|
      @summary[result.test_type] = @test_runs.map do |tr|
        tr.results.where(test_type: result.test_type).map do |r|
          r.score
        end
      end.flatten
    end
  end

  def can_graph?
    !@test_runs.empty?
  end
end
