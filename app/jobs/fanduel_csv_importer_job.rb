class FanduelCsvImporterJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      file_contents = args[:file_contents]
      user = User.find(args[:user])
      errors = []
      CSV.parse(file_contents).each do |row|
        begin
          next if row[2] == "Date"
          next if Entry.find_by_site_entry_id row[0].gsub(/\D/, '')
          next if row[5].blank?

          site = Site.where(name: "fanduel").first_or_create
          player = Account.where(site: site, user: user).first_or_create

          entry_fee = row[10].to_f * 100
          winnings = row[11].to_f * 100
          profit = winnings - entry_fee

          entry = player.entries.create!(
            site_id: site.id,
            site_entry_id: row[0].gsub(/\D/, ''),
            sport: row[1],
            score: row[5],
            position: row[7],
            total_entries: row[8],
            contest_title: row[3],
            opponent_username: row[9],
            entry_fee_in_cents: entry_fee,
            winnings_in_cents: winnings,
            link: row[12],
            profit: profit,
            entered_on: Date.strptime(row[2], '%Y/%m/%d'),
            user_id: user.id
          )
        rescue
          Rails.logger.error("#{user.id} - #{row.inspect} failed to import")
          errors << "#{user.id} - #{row.inspect} failed to import"
          next
        end
      end
      ExceptionMailer.csv_import_errors_email(errors).deliver_later

    end
  end

end
