module PercentageHelper
  def ratio_to_percentage(ratio)
    "#{(ratio * 100).round(2)}%"
  end
end
