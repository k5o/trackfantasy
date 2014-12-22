class FanduelCsvImporter

  def initialize file_location = "db/seed/fanduel_example.csv"
    @file = File.open(file_location)
  end

  def import
    CSV.foreach(@file).first(10).each do |row|
      next if row[2] == "Date"
      site = Site.where(name: "fanduel").first_or_create
      user = User.where(username: "yudarvish").first_or_create
      player = DfsAccount.where( username: "yudarvish", site: site ).first_or_create
      if row[9]
        opponent = DfsAccount.where( username: row[9], site: site ).first_or_create
      end
      url = HTTParty.get(row[12]).request.last_uri.to_s
      contest = Contest.where(site: site, sport: row[1].downcase, site_contest_id: url.scan(/\d+/).last ).first_or_create
      unless contest.title
        contest.update title: row[3], entrants: row[8], completed_on: Date.strptime(row[2], '%Y/%m/%d'), link: url, buy_in: row[10]
      end
      player.entries.create!(
        contest: contest,
        site_entry_id: row[0],
        score: row[5],
        position: row[7],
        opponent_username: opponent.username,
        entry_fee: row[10],
        winnings: row[11],
        link: row[12],
      )
      if row[9] == "Tournament"
        FanduelContestImporter.new(url).import
      else
        opponent.entries.create!(
          contest: contest,
          site_entry_id: row[0].gsub(/\D/, ''),
          score: row[5],
          opponent_username: player.username,
        )
      end

    end
  end

end
