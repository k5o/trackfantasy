# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  attr_reader :user, :date_range, :account

  def initialize(user, date_range = nil, site = nil)
    validate_input(user, date_range, site)
    @user = user

    # Get entries
    if date_range.first.present? && date_range.last.present?
      @entries = @user.entries.where("entered_on >= ? AND entered_on <= ?", date_range.first, date_range.last).order(:entered_on)
    else
      @entries = @user.entries.order(:entered_on)
    end

    if site
      site_id = Site.find_by_name(site).try(:id)

      @entries.includes(:account).where(accounts: {site_id: site_id})
    end
  end

  def winnings
    @entries.sum(:winnings)
  end

  def entry_fees
    @entries.sum(:entry_fee)
  end

  def revenue_amount
    winnings - entry_fees
  end

  def day_profit
    # TODO: Possibly a postgres window function (OVER) to speed up this operation
    dates_and_entry_profits = @entries.reduce({}) do |result, entry|
      unix_time_datestamp_in_milliseconds = (entry.entered_on.to_time.to_f * 1000).to_i
      result[unix_time_datestamp_in_milliseconds] ||= []
      result[unix_time_datestamp_in_milliseconds] << entry.profit

      result
    end

    result = {}

    dates_and_entry_profits.each do |date, profits|
      result[date] = profits.inject(:+)
    end

    result
  end

  def running_revenue_list_by_date
    running_count = 0
    result = {}

    day_profit.each do |date, profit|
      running_count += profit
      result[date] = running_count
    end

    result
  end

  def graph_axes
    dates_and_profits = running_revenue_list_by_date
    x_axis = dates_and_profits.values
    y_axis = dates_and_profits.keys

    y_axis.zip(x_axis)
  end

  def roi
    (revenue_amount / entry_fees) * 100
  end

  def total_entries
    @entries.count
  end

  def date_of_first_entry
    @entries.first.entered_on
  end

  def biggest_day_entry
    day_profit.sort_by {|k,v| v}.last
  end

  def biggest_day
    biggest_day_entry.last
  end

  def biggest_day_date
    Time.at(biggest_day_entry.first / 1000).to_date
  end

  def biggest_score
    @entries.maximum(:winnings)
  end

  def biggest_score_date
    @entries.find_by_winnings(biggest_score).try(:entered_on)
  end

  private

  def validate_input(user, date_range, site)
    raise 'Invalid entry' unless user.kind_of?(User)

    if date_range && date_range.first.present? && date_range.last.present?
      from_date = date_range.first.to_date
      to_date = date_range.last.to_date

      raise 'Invalid entry' unless from_date.kind_of?(Date) && to_date.kind_of?(Date) && to_date >= from_date
    end

    if site
      raise 'Invalid entry' unless Site::NAMES.include?(site)
    end
  end
end