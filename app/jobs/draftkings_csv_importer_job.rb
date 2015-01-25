class DraftkingsCsvImporterJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      file_contents = args[:file_contents]
      user = User.find(args[:user])
      site = Site.where(name: "draftkings").first_or_create
      last_entry_date = user.entries.last.entered_on if user.entries.try(:last)
      errors = [user.email]

      CSV.parse(file_contents).each do |row|
        begin
          # Define the CSV
          sport           = row[0]
          contest_title   = row[1]
          date            = row[2]
          position        = row[3]
          score           = row[4]
          winnings        = row[5]
          winnings_ticket = row[6]
          total_entries   = row[7]
          entry_fee       = row[8]
          prize_pool      = row[9]
          places_paid     = row[10]

          # Validations
          next if row.length != 11 # Validate that we're on the right CSV version
          next if places_paid == "Places_Paid" # Skip headers
          next if score.blank? || winnings.blank? || entry_fee.blank? # Required
          entry_id = Base64.encode64("#{contest_title}#{date}")
          next if user.entries.where(entry_id: entry_id) && last_entry_date && Date.strptime(date[0..9], '%Y-%m-%d') < last_entry_date # Skip if already imported

          # Pre-formatting
          entry_fee = entry_fee.sub(/\D/,'').to_f * 100
          winnings = winnings.sub(/\D/,'').to_f * 100
          profit = winnings - entry_fee
          opponent_username = contest_title.include?("vs.") ? contest_title.split('vs. ').last : "Tournament"
          entered_on = Date.strptime(date[0..9], '%Y-%m-%d')

          # Creation
          entry = user.entries.create(
            site_id: site.id,
            site_entry_id: entry_id,
            game_type: Entry.define_game_type(contest_title.downcase, total_entries),
            sport: sport.downcase,
            score: score,
            position: position,
            total_entries: total_entries,
            contest_title: contest_title,
            opponent_username: opponent_username,
            entry_fee_in_cents: entry_fee,
            winnings_in_cents: winnings,
            profit: profit,
            entered_on: entered_on,
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