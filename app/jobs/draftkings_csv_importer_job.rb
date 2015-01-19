class DraftkingsCsvImporterJob < ActiveJob::Base

  def perform args
    ActiveRecord::Base.connection_pool.with_connection do
      file_contents = args[:file_contents]
      user = User.find(args[:user])
      last_entry_date = user.entries.last.entered_on if Entry.last
      errors = []
      CSV.parse(file_contents).each do |row|
        begin
          next if row[0] == "Sport"
          entry_id = Base64.encode64("#{row[1]}#{row[2]}")
          next if user.entries.where(entry_id: entry_id) && last_entry_date && Date.strptime(row[2][0..9], '%Y-%m-%d') < last_entry_date

          site = Site.where(name: "draftkings").first_or_create
          player = Account.where(site: site, user: user).first_or_create

          entry_fee = row[8].gsub(/\D/,'').to_f / 100
          winnings = row[5].gsub(/\D/,'').to_f / 100
          profit = winnings - entry_fee

          entry = player.entries.create(
            site_id: site.id,
            site_entry_id: entry_id,
            game_type: game_type(row[1].downcase, row[7].to_i)
            sport: row[0].downcase,
            score: row[4],
            position: row[3],
            total_entries: row[7],
            contest_title: row[1],
            opponent_username: row[1].include?("vs.") ? row[1].split('vs. ').last : "Tournament",
            entry_fee_in_cents: entry_fee,
            winnings_in_cents: winnings,
            profit: profit,
            entered_on: Date.strptime(row[2][0..9], '%Y-%m-%d'),
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

  def game_type(name, entries)
    if name.includes?("head")
      "h2h"
    elsif name.includes?("50/50")
      "50/50"
    elsif name.includes?("double")
      "Double Up"
    elsif name.includes?("triple")
      "Triple Up"
    elsif name.includes?("matrix")
      "Matrix"
    elsif entries > 10
      "GPP"
    else
      "#{entries} player league"
    end
  end


end
