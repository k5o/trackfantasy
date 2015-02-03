# TODO: Cache this return, or its individual calculations
# but invalidate once user uploads new file, OR date_range changes
class Dashboard::AnalyticsCalculator
  delegate :params, :h, :link_to, :number_to_currency, :number_to_percentage, to: :@view

  def initialize(view)
    @view = view
    @user = @view.assigns["current_user"]
    @date_range = nil || @view.assigns["date_range"]
    @site = @view.assigns["site"].present? && @view.assigns["site"]
    @sport = @view.assigns["sport"].present? && @view.assigns["sport"]

    return false unless valid?
  end

  def entries
    @entries ||= begin
      if @date_range && @date_range.first.present? && @date_range.last.present?
        scope = @user.entries.where("entered_on >= ? AND entered_on <= ?", @date_range.first, @date_range.last)
      else
        scope = @user.entries
      end

      if @site
        site_id = Site.find_by_name(@site).try(:id)

        scope = scope.where(site_id: site_id)
      end

      if @sport
        scope = scope.where(sport: @sport)
      end

      scope
    end
  end

  def games_data
    games.map do |game|
      [
        game.count, # entries
        (game.entry_fee_in_cents / 100.0), # entry_fee_in_cents
        game.game_type, # game type
        (game.profit.to_f / 100.0), # profit sum
        (game.roi.to_f * 100.0).round(2), # roi percentage
        number_to_percentage(game.winrate.to_f * 100.0, precision: 2), # winrate percentage
        game.score.to_f.round(2) # average score
      ]
    end
  end

  def games
    return [] unless @sport

    entries.group(:entry_fee_in_cents, :game_type).order("count DESC").select(<<-SQL)
      entry_fee_in_cents, game_type,
      count(*) as count,
      sum(profit) as profit,
      sum(profit) / nullif(sum(entry_fee_in_cents), 0)::float8 as roi,
      sum(CASE profit > 0 when true then 1 else 0 end)::float8 / count(*)::float8 as winrate,
      avg(score)::float8 as score
    SQL
  end

  def games_total
    {
      total_entries: total_entries,
      total_profit: total_profit,
      roi: roi,
      winrate: winrate,
      average_score: average_score,
    }
  end

  def entries_exist
    @entries_exist ||= entries.exists?
  end

  def entry_fees
    @entry_fees ||= entries.sum(:entry_fee_in_cents).to_i / 100.0
  end

  def revenue_amount
    @revenue_amount ||= entries.sum(:profit).to_i / 100.0
  end

  def total_profit
    entries.sum(:profit).to_i / 100.0
  end

  def graph_axes
    return [0,0] unless entries_exist

    axes = entries.group("entered_on").pluck <<-SQL
      extract(epoch from entered_on) * 1000,
      sum(sum(profit)::float / 100.0) over (order by entered_on)
    SQL
  end

  def roi
    entry_fees > 0 ? (revenue_amount / entry_fees.to_f) * 100 : 0
  end

  def total_entries
    @total_entries ||= entries.count
  end

  def winrate
    games_won = entries.where('profit > ?', 0).count

    nil_guard_value || (games_won / @total_entries.to_f) * 100
  end

  def average_score
    entries.average(:score)
  end

  def date_of_first_entry
    nil_guard_text || entries.order(:entered_on).first.try(:entered_on)
  end

  def biggest_day_entry
    entries_by_profit = entries.group(:entered_on).order('profit DESC').select(<<-SQL)
      entered_on,
      sum(profit) as profit
    SQL

    @biggest_day_entry ||= nil_guard_text || entries_by_profit.first
  end

  def biggest_day
    nil_guard_value || biggest_day_entry.profit / 100.0
  end

  def biggest_day_date
    nil_guard_text || biggest_day_entry.try(:entered_on)
  end

  def biggest_score
    nil_guard_value || entries.maximum(:winnings_in_cents) / 100.0
  end

  def biggest_score_date
    nil_guard_text || entries.find_by_winnings_in_cents(biggest_score * 100).try(:entered_on)
  end

  def sports_data
    return false if @sport

    # 0 => sport, 1 => Count, 2 => Profit
    sports_data = entries.group(:sport).pluck("sport, count(*), sum(profit)").sort_by {|e| e.last}.reverse

    return false if sports_data.length <= 1

    sports_data.map {|sport, count, profit| [sport, count, profit / 100.0] }
  end

  def sites_data
    return false if @site

    # 0 => site_id, 1 => Count, 2 => Profit
    sites_data = entries.group(:site_id).pluck("site_id, count(*), sum(profit)").sort_by {|e| e.last}.reverse

    return false if sites_data.length <= 1

    sites_data.map {|site_id, count, profit| [Site.find_by_id(site_id).try(:name), count, profit / 100.0] }
  end

  def profit_per_day
    return nil_guard_value if nil_guard_value

    days = entries.pluck(:entered_on).uniq!

    total_profit / days.count.to_f
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

  private

  def nil_guard_value
    0 unless entries_exist
  end

  def nil_guard_text
    'N/A' unless entries_exist
  end
end
