class Dashboard::Games
  delegate :params, :h, :link_to, :number_to_currency, :number_to_percentage, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    data
  end

private

  def data
    games.map do |game|
      [
        game.count, # entries
        game.game_type, # game type
        number_to_currency(game.entry_fee_in_cents / 100.0), # entry_fee_in_cents
        number_to_currency(game.profit), # profit sum
        number_to_percentage(game.roi, precision: 2), # roi percentage
        number_to_percentage(game.winrate, precision: 2), # winrate percentage
        game.score.to_f.round(2) # average score
      ]
    end
  end

  def games
    @view.current_user.entries.where(sport: 'nba').group(:game_type, :entry_fee_in_cents).order(:entry_fee_in_cents).select(<<-SQL)
      game_type, entry_fee_in_cents,
      count(*) as count,
      sum(profit) / 100.0 as profit,
      sum(profit) / 100.0 / nullif((sum(entry_fee_in_cents) / 100.0), 0) as roi,
      sum(CASE profit > 0 when true then 1 else 0 end) / count(*) as winrate,
      avg(score)::float8 as score
    SQL
  end

  def fetch_games
    filtered_games = games.order("#{sort_column} #{sort_direction}")
    filtered_games = filtered_games.page(page).per_page(per_page)
    if params[:sSearch].present?
      filtered_games = filtered_games.where("name like :search or category like :search", search: "%#{params[:sSearch]}%")
    end
    filtered_games
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[count game_type entry_fee_in_cents profit roi winrate score]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end