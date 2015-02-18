class Entry < ActiveRecord::Base
  SPORTS = ['nfl', 'nba', 'mlb', 'nhl', 'cfb', 'cbb', 'mma', 'pga', 'soc']

  belongs_to :account
  belongs_to :contest
  belongs_to :user
  belongs_to :site

  validates :site_entry_id, uniqueness: true, allow_nil: true

  def self.define_game_type(name, entries)
    if name.include?("head")
      "H2H"
    elsif name.include?("50/50")
      "50/50"
    elsif name.include?("double")
      "Double Up"
    elsif name.include?("triple")
      "Triple Up"
    elsif name.include?("matrix")
      "Matrix"
    elsif entries.to_i > 10
      "GPP"
    else
      "League (#{entries})"
    end
  end

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

  def fanduel?
    site_id == Site.fanduel_site_id
  end
end
