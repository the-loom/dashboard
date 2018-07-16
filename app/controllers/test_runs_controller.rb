class TestRunsController < ApplicationController
  def show
    @test_run = AutomaticCorrection::TestRun.find(params[:id])
    @repo = @test_run.repo
  end
end
