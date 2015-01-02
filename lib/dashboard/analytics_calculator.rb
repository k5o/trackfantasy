# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  attr_reader :user, :date_range, :account

  def initialize(user, date_range = nil, site = nil)
    validate_input(user, date_range, site)
    @user = user

    # Get entries
    if date_range.first.present? && date_range.last.present?
      @entries = @user.entries.where("entered_on >= ? AND entered_on <= ?", date_range.first, date_range.last)
      @date_range = date_range
    else
      @entries = @user.entries
      @date_range = (@entries.last..@entries.first)
    end

    if site
      site_id = Site.find_by_name(site).id # Site has been validated by this point

      @entries.includes(:account).where(accounts: {site_id: site_id})
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

  def date_of_first_entry
    @entries.first.entered_on
  end

  private

  def validate_input(user, date_range, site)
    raise 'Invalid entry' unless user.kind_of?(User)

    if date_range.first.present? && date_range.last.present?
      from_date = date_range.first.to_date
      to_date = date_range.last.to_date

      raise 'Invalid entry' unless from_date.kind_of?(Date) && to_date.kind_of?(Date) && to_date >= from_date
    end

    if site
      raise 'Invalid entry' unless Site::NAMES.include?(site)
    end
  end
end