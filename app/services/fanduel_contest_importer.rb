require 'open-uri'
class FanduelContestImporter

  def initialize url = "http://www.fanduel.com/contest/8133183/scoring/lineup/90032970/"
    game_id, entry_id = url.scan(/\d+/)
    @doc ||= HTTParty.get("https://livescoring.fanduel.com/table/#{game_id}?start=0&seats=#{entry_id}")
  end

  def parse_and
    @doc
  end

end
