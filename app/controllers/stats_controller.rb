class StatsController < ApplicationController
  def points
    @calculator = ScoreCalculator.new
  end
end
