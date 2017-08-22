class SolutionsController < ApplicationController
  def show
    #authorize Lecture
    5/0
    @solution = Solution.find(params[:id])
  end

end
