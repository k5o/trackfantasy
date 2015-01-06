class Entry < ActiveRecord::Base
  SPORTS = ['nfl', 'nba', 'mlb', 'nfl', 'cfb', 'cbb', 'mma']

  belongs_to :account
  belongs_to :contest
  belongs_to :user

  def self.create_from_fanduel_seat data, contest
    site = Site.where(name: "fanduel").first_or_create
    player = Account.where(site_user_id: data["user_id"], site: site).first_or_create
    if not player.has_username?
      player.update username: HTTParty.get("https://livescoring.fanduel.com/users?users=#{player.site_user_id}")[0]["name"]
    end
    player.entries.create!(
      contest: contest,
      site_entry_id: data["id"],
      score: data["score"],
      position: data["rank"],
      entry_fee: contest.buy_in,
      winnings: data["prize"],
    )
  end

  def winnings
    winnings_in_cents / 100.0
  end

  def entry_fee
    entry_fee_in_cents / 100.0
  end
end
