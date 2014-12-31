# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  attr_reader :user, :date_range, :account

  def initialize(user, date_range = nil, site = nil)
    return false unless user.kind_of?(User)

    @user = user

    if account
      @accounts = account
    else
      @accounts = @user.accounts
    end

    # Get entries
    if date_range
      @entries = @user.entries.where("entered_on >= ? AND entered_on <= ?", date_range.first, date_range.last)
      @date_range = date_range
    else
      @entries = @user.entries
      @date_range = (@entries.last..@entries.first)
    end

    @entries = @entries.sort_by(&:entered_on)
  end

  def winnings
    @entries.map(&:winnings).inject(:+)
  end

  def entry_fees
    @entries.map(&:entry_fee).inject(:+)
  end

  def revenue_amount
    winnings - entry_fees
  end

  def running_revenue_list_by_date
    dates_and_entry_profits = @entries.reduce({}) do |result, entry|
      unix_time_datestamp_in_milliseconds = (entry.entered_on.to_time.to_f * 1000).to_i
      result[unix_time_datestamp_in_milliseconds] ||= []
      result[unix_time_datestamp_in_milliseconds] << entry.profit

      result
    end

    running_count = 0

    revenue_list_by_date = dates_and_entry_profits.each do |date, profits|
      running_count += profits.inject(:+)
      dates_and_entry_profits[date] = running_count
    end

    revenue_list_by_date
  end

  def graph_axes
    dates_and_profits = running_revenue_list_by_date
    x_axis = dates_and_profits.values
    y_axis = dates_and_profits.keys

    y_axis.zip(x_axis)
  end

  def roi
    ((winnings - entry_fees) / entry_fees) * 100
  end

  def total_entries
    @entries.count
  end
end