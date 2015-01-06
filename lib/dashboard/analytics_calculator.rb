# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  attr_reader :user, :date_range, :account

  def initialize(user, date_range = nil, site = nil, sport = nil)
    @user = user
    @date_range = date_range
    @site = site.present? && site
    @sport = sport.present? && sport

    return false unless valid?

    # Get entries
    if date_range.first.present? && date_range.last.present?
      @entries = @user.entries.where("entered_on >= ? AND entered_on <= ?", date_range.first, date_range.last)
    else
      @entries = @user.entries
    end

    if @site
      site_id = Site.find_by_name(@site).try(:id)

      @entries = @entries.includes(:account).where(accounts: {site_id: site_id}) # Possibly more performant if we remove account join
    end

    if @sport
      @entries = @entries.where(sport: @sport)
    end

    @entries_exist = @entries.any?
  end

  def entry_fees
    if @entries_exist
      @entries.sum(:entry_fee_in_cents) / 100.0
    else
      0
    end
  end

  def revenue_amount
    if @entries_exist
      @entries.sum(:profit) / 100.0
    else
      0
    end
  end

  def graph_axes
    if @entries_exist
      @entries.group("entered_on").pluck <<-SQL
        extract(epoch from entered_on) * 1000,
        sum(sum(profit)::float8 / 100.0) over (order by entered_on)
      SQL
    else
      [0,0]
    end
  end

  def roi
    if entry_fees > 0
      (revenue_amount / entry_fees.to_f) * 100
    else
      0
    end
  end

  def total_entries
    @entries.count
  end

  def winrate
    if @entries_exist
      games_won = @entries.where('profit > ?', 0).count
      (games_won / total_entries.to_f) * 100
    else
      0
    end
  end

  def date_of_first_entry
    if @entries_exist
      @entries.sort_by(&:entered_on).first.try(:entered_on)
    else
      'N/A'
    end
  end

  def biggest_day_entry
    @entries.sort_by(&:profit).try(:last)
  end

  def biggest_day
    if biggest_day_entry
      biggest_day_entry.profit / 100.0
    else
      0
    end
  end

  def biggest_day_date
    if biggest_day_entry
      biggest_day_entry.entered_on
    else
      'N/A'
    end
  end

  def biggest_score
    if @entries_exist
      @entries.maximum(:winnings_in_cents) / 100.0
    else
      0
    end
  end

  def biggest_score_date
    if @entries_exist
      @entries.find_by_winnings_in_cents(biggest_score * 100).try(:entered_on)
    else
      'N/A'
    end
  end

  def sports_data
    # 0 => sport, 1 => Count, 2 => Profit
    sports_data = @entries.group(:sport).pluck("sport, count(*), sum(profit)").sort_by {|e| e.last}.reverse

    sports_data.map {|sport, count, profit| [sport, count, profit / 100.0] }
  end

  def sites_and_data
    # {:fanduel => [5000, 1299.99]}
  end

  def valid?
    return false unless @user.kind_of?(User)

    if @date_range && @date_range.first.present? && @date_range.last.present?
      from_date = @date_range.first.to_date
      to_date = @date_range.last.to_date

      return false unless from_date.kind_of?(Date) && to_date.kind_of?(Date) && to_date >= from_date
    end

    if @site.present?
      return false unless Site::NAMES.include?(@site)
    end

    if @sport.present?
      return false unless Entry::SPORTS.include?(@sport)
    end

    true
  end
end
