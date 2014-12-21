class FanduelCsvImporter

  def initialize file_location = "tmp/fanduel_example.csv"
    @file = File.open(file_location)
  end

  def import
    CSV.foreach(@file).each do |row|
      next if row[2] == "Date"
      site = Site.where(name: "fanduel").first_or_create
      user = User.where(username: "yudarvish").first_or_create
      player = DfsAccount.where( username: "yudarvish", site: site ).first_or_create
      if row[9]
        opponent = DfsAccount.where( username: row[9], site: site ).first_or_create
      end
      contest = site.contests.create!(
        sport: row[1],
        completed_on: Date.strptime(row[2], '%Y/%m/%d'),
        title: row[3],
        entrants: row[8],
        link: row[12],
        )
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
      if row[9]
        opponent.entries.create!(
          contest: contest,
          site_entry_id: row[0],
          score: row[5],
          opponent_username: player.username,
        )
      end

      # FanduelContestImporter
    end
  end

end
