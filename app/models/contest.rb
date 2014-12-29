class Contest < ActiveRecord::Base
  belongs_to :site
  has_many :entries

  def buy_in
    buy_in_in_cents / 100.0
  end

  def total_prizes_paid
    total_prizes_paid_in_cents / 100.0
  end

  def type
    if entrants == 2
      "h2h"
    elsif entrants > 2 && entrants < 11
      "league"
    else
      "tournament"
    end
  end
end
