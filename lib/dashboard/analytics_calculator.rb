# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  attr_reader :user, :date_range, :account, :accounts

  # TODO: there's probably a better way to set beginning of time)
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
      contests = []

      @accounts.each do |account|
        contests += account.entries.map(&:contest_id)
      end

      all_contests = Contest.where("id in (?)", contests).sort_by(&:completed_on)
      first_contest = all_contests.last.completed_on
      last_contest = all_contests.first.completed_on
      @date_range = (first_contest..last_contest).map {|d| d}
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

  def running_revenue_list
    entries = []

    @accounts.each do |account|
      # entries << account.entries.where("entry.entered_on BETWEEN #{@date_range}")
      entries = account.entries
    end

    dates_and_entry_profits = entries.sort_by(&:entered_on).reduce({}) do |result, entry|
      result[entry.entered_on] ||= []
      result[entry.entered_on] << entry.profit

      result
    end

    revenue_list_by_date = dates_and_entry_profits.each do |date, profits|
      dates_and_entry_profits[date] = profits.inject(:+)
    end

    binding.pry

    revenue_list_by_date
  end

  def graph_points
    running_revenue_list
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