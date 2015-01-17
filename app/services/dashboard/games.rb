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
    @games.map do |game|
      [
        game.entries.count,
        number_to_currency(game.buyin_in_cents),
        game.type,
        number_to_currency(game.entry_total_profit),
        number_to_percentage(game.roi, precision: 2),
        number_to_percentage(game.winrate, precision: 2),
        game.average_score
      ]
    end
  end

  def games
    @games ||= @user.games.where().order('buyin_in_cents', 'type')
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
    columns = %w[buyin_in_cents type entry_total_profit roi average_score]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end