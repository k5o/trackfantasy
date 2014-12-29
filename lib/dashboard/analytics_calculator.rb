# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  attr_reader :user, :date_range, :account, :accounts

  def initialize(user, date_range = nil, account = nil)
    return false unless user.kind_of?(User)

    @user = user

    if account
      @accounts = account
    else
      @accounts = @user.accounts
    end

    if date_range
      @date_range = date_range
    else
      entries = []

      @accounts.each do |account|
        entries += account.entries
      end

      entries = entries.sort_by(&:entered_on)
      first_contest = entries.last.entered_on
      last_contest = entries.first.entered_on
      @date_range = first_contest..last_contest
    end
  end

  def winnings
    total_winnings = 0

    @accounts.each do |account|
      total_winnings += account.entries.map(&:winnings).inject(:+)
    end

    total_winnings.to_f
  end

  def entry_fees
    total_entry_fees = 0

    @accounts.each do |account|
      total_entry_fees += account.entries.map(&:entry_fee).inject(:+)
    end

    total_entry_fees.to_f
  end

  def revenue_amount
    winnings - entry_fees
  end

  def running_revenue_list_by_date
    entries = []

    @accounts.each do |account|
      # entries << account.entries.where("entry.entered_on BETWEEN #{@date_range}")
      entries = account.entries
    end

    dates_and_entry_profits = entries.sort_by(&:entered_on).reduce({}) do |result, entry|
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

  def running_revenue_list_by_entry
    entries = []

    @accounts.each do |account|
      # entries << account.entries.where("entry.entered_on BETWEEN #{@date_range}")
      entries = account.entries
    end

    entry_profits = entries.sort_by(&:entered_on).map(&:profit)

    running_count = []

    entry_profits.reduce(0) do |result, profit|
      result = profit + result
      running_count << result

      result
    end

    running_count
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
    entries = 0

    @accounts.each do |account|
      entries += account.entries.count
    end

    entries
  end
end