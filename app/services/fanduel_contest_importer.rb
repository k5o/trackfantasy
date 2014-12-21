require 'open-uri'
class FanduelContestImporter

  def initialize url = "https://www.fanduel.com/contest/8708446/scoring/lineup/96601070/"
    @game_id, @entry_id = url.scan(/\d+/)
    @api_game_url = "https://livescoring.fanduel.com/table/#{game_id}?start="
    @doc ||= HTTParty.get("#{@api_base_url}0")
    @number_of_seats = @doc["table"]["seat_count"].to_i
    "https://livescoring.fanduel.com/users?users=210526"
    "https://livescoring.fanduel.com/table/8708446?start=20"
  end

  def import
    0.upto(iterations_needed).each |i|
      doc = HTTParty.get("#{@api_base_url}#{i * 10}")
      parse(doc)
    end
  end

  private

  def parse doc
    doc
  end

  def iterations_needed
    (@number_of_seats / 10)
  end

end
