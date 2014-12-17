# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class AnalyticsCalculator
  attr_reader :user, :date_range

  # TODO: there's probably a better way to set beginning of time)
  def initialize(user, date_range = (Time.current - 10.years..Time.current))
    return false unless user.kind_of?(User) && date_range.kind_of?(Range)

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