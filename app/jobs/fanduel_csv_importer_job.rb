class FanduelCsvImporterJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      filename = args[:filename]
      user = User.find(args[:user])
      site = Site.where(name: "fanduel").first_or_create
      errors = [user.email]
      entries = []
      start_time = Time.now
      counter = 0
      full_path = "#{Constants::TEMP_PATH}#{filename}"
      date_format = nil

      begin
        if ImportHelper.store_s3_file!(filename)
          CSV.parse(ImportHelper.s3_file_value(filename)).each do |row|
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
              next unless row.length == 14 || row.length == 13 # Validate that we're on the right CSV version
              next if link == "Link" # Skip headers
              next if blank_in_csv == "endedunmatched" # Skip headers
              next if score.blank? || winnings.blank? || entry_fee.blank? # Required
              next if user.entries.where(site_entry_id: site_entry_id).any? # Skip if already imported

              # Pre-formatting
              entry_fee = entry_fee.to_f * 100
              winnings = winnings.to_f * 100
              profit = winnings - entry_fee
              date_format ||= date[0..1] == '20' ? '%Y/%m/%d' : '%m/%d/%Y'
              entered_on = Date.strptime(date, date_format)

              # Creation
              entry = Entry.new(
                site_id: site.id,
                user_id: user.id,
                site_entry_id: site_entry_id,
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
                entered_on: entered_on
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
          ImportHelper.delete_tmp_file!(filename)
          ImportHelper.delete_s3_file!(filename) if errors.length > 1

          import_speed = (counter / (Time.now - start_time)).round(2)
          event = Event.find_by_id(args[:event])
          ImportTime.create(rows_per_second: import_speed, event: event, site: site) if event

          Rails.logger.debug("IMPORT RESULTS: #{counter} entries imported #{((Time.now - start_time) / 60).round(2)} minutes (#{import_speed} entries/second)")
        end
      rescue StandardError => e
        Rails.logger.error(e)
        errors << e
      end

      if errors.length > 1
        errors.unshift(filename) # Append filename to error email so admin can retrieve it on S3
        ExceptionMailer.csv_import_errors_email(errors).deliver_now
      end
    end
  end
end
