class DraftkingsCsvImporterJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      filename = args[:filename]
      user = User.find(args[:user])
      site = Site.where(name: "draftkings").first_or_create
      last_entry_date = user.entries.maximum(:entered_on)
      errors = [user.email]
      entries = []
      start_time = Time.now
      counter = 0
      full_path = "#{Constants::TEMP_PATH}#{filename}"

      begin
        if ImportHelper.store_s3_file!(filename)
          CSV.parse(ImportHelper.s3_file_value(filename)).each do |row|
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
              binding.pry
              next if user.entries.where(site_entry_id: entry_id).any? && last_entry_date && Date.strptime(date[0..9], '%Y-%m-%d') < last_entry_date # Skip if already imported
              binding.pry
              # Pre-formatting
              entry_fee = entry_fee.gsub(/[^\d\.]/, '').to_f * 100
              winnings_ticket = winnings_ticket.gsub(/[^\d\.]/, '').to_f
              winnings = winnings_ticket > 0 ? winnings_ticket * 100 : winnings.gsub(/[^\d\.]/, '').to_f * 100
              profit = winnings - entry_fee
              opponent_username = contest_title.include?("vs.") ? contest_title.split('vs. ').last : "Tournament"
              entered_on = Date.strptime(date[0..9], '%Y-%m-%d')

              # Creation
              entry = Entry.new(
                site_id: site.id,
                user_id: user.id,
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

              entries << entry
              counter += 1
            rescue StandardError => e
              Rails.logger.error("#{row.inspect} - #{e}")
              errors << "#{row.inspect} - #{e}"
              next
            end
          end

          Entry.import(entries) # batch import all entries
          ImportHelper.delete_files!(filename) # delete temp and s3 files

          import_speed = (counter / (Time.now - start_time)).round(2)
          event = Event.find_by_id(args[:event])
          event.store_speed!(import_speed) if event

          Rails.logger.debug("IMPORT RESULTS: #{counter} entries imported #{((Time.now - start_time) / 60).round(2)} minutes (#{import_speed} entries/second)")
        end
      rescue StandardError => e
        Rails.logger.error(e)
        errors << e
      end

      if errors.length > 1
        ExceptionMailer.csv_import_errors_email(errors).deliver_later
      end
    end
  end
end
