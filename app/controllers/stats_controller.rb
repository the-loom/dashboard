class StatsController < ApplicationController
  layout "application5"

  def points
    @calculator = ScoreCalculator.new
  end
end
