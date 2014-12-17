# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file
class AnalyticsDecorator
  attr_reader :user, :date_range

  def initialize(user, date_range)
    @user = user
    @date_range = date_range
  end

  def graph_points
  end

  def revenue_amount
  end

  def roi
  end

  def games_played
  end
end