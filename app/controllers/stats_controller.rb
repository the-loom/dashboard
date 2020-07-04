class StatsController < ApplicationController
  layout "application2"

  def points
    @calculator = ScoreCalculator.new
  end
end
