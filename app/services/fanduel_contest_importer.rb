require 'open-uri'
class FanduelContestImporter

  def initialize url = "https://www.fanduel.com/contest/8708446/scoring/lineup/96601070/"
    @game_id, @entry_id = url.scan(/\d+/)
    @api_game_url = "https://livescoring.fanduel.com/table/#{@game_id}?start="
    @doc ||= HTTParty.get("#{@api_game_url}0")
    @number_of_seats = @doc["table"]["seat_count"].to_i
    @sport = @doc["table"]["sport"].downcase
    @contest = Contest.where(site: "fanduel", sport: @sport, site_contest_id: @game_id).first_or_create
    unless @contest.title
      @contest.update title: @doc["table"]["name"], entrants: @doc["table"]["seat_count"], completed_on: Date.strptime(@doc["table"]["start_date"].to_s,'%s'), link: url
    end
  end

  def import
    0.upto(iterations_needed).each do |i|
      import_page(page_at_index i * 10)
    end
  end

  private

  def import_page page
    page["seats"].each do |s|
      Entry.create_from_fanduel_seat s, @contest
    end
  end

  def iterations_needed
    3
    # (@number_of_seats / 10)
  end

  def page_at_index i
    doc = HTTParty.get("#{@api_game_url}#{i}")
  end

end
