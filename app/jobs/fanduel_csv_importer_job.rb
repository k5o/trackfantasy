class FanduelCsvImporterJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      file_contents = args[:file_contents]
      user = User.find(args[:user])
      site = Site.where(name: "fanduel").first_or_create
      errors = [user.email]

      CSV.parse(file_contents).each do |row|
        begin
          # Define the CSV
          site_entry_id     = row[0]
          sport             = row[1]
          date              = row[2]
          contest_title     = row[3]
          salary_cap        = row[4]
          score             = row[5]
          position          = row[7]
          total_entries     = row[8]
          opponent_username = row[9]
          entry_fee         = row[10]
          winnings          = row[11]
          link              = row[12]
          blank_in_csv      = row[13]

          # Validations
          next if row.length != 14 # Validate that we're on the right CSV version
          next if link == "Link" # Skip headers
          next if score.blank? || winnings.blank? || entry_fee.blank? # Required
          next if user.entries.find_by_site_entry_id(site_entry_id.sub(/\D/, '')) # Skip if already imported

          # Pre-formatting
          entry_fee = entry_fee.to_f * 100
          winnings = winnings.to_f * 100
          profit = winnings - entry_fee

          # Creation
          entry = user.entries.create!(
            site_id: site.id,
            site_entry_id: site_entry_id.sub(/\D/, ''),
            game_type: Entry.define_game_type(contest_title.downcase, total_entries),
            sport: sport,
            score: score,
            position: position,
            total_entries: total_entries,
            contest_title: contest_title,
            opponent_username: opponent_username,
            entry_fee_in_cents: entry_fee,
            winnings_in_cents: winnings,
            link: link,
            profit: profit,
            entered_on: Date.strptime(date, '%Y/%m/%d')
          )
        rescue StandardError => e
          Rails.logger.error("#{row.inspect} - #{e}")
          errors << "#{row.inspect} - #{e}"
          next
        end
      end

      if errors.length > 1
        ExceptionMailer.csv_import_errors_email(errors).deliver_later
      end
    end
  end
end
