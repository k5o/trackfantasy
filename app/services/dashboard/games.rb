class Dashboard::Games
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      draw: ,
      recordsTotal: ,
      recordsFiltered: ,
      data: data,
      error: 
    }
  end

private

  def data
    games.map do |game|
      [
        game.count, # entries
        number_to_currency(game[1]), # entry_fee_in_cents
        game[2], # game type
        number_to_currency(game[3]), # profit sum
        number_to_percentage(game[4], precision: 2), # roi percentage
        number_to_percentage(game[5], precision: 2), # winrate percentage
        game[6] # average score
      ]
    end
  end

  def games
    @user.entries.group(:entry_fee_in_cents, :sport).select(<<-SQL)
      entry_fee_in_cents, sport,
      count(*) as count,
      sum(profit) as profit
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
    columns = %w[entry_fee_in_cents type entry_total_profit roi average_score]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end