class AggregateFromEntries

  def initialize(user)
    @user = user
  end

  def perform
    @user.entries.unaggregated.each do |e|
      ds = @user.date_stats.where( date: e.entered_on ).first_or_create
      type = e.contest.type
      sport = e.contest.sport
      site = e.contest.site.name
      won_lost = e.winnings_in_cents - e.entry_fee_in_cents
      ds.stat_hash[:total_in_cents] ? ds.stat_hash[:total_in_cents] += won_lost : ds.stat_hash[:total_in_cents] = won_lost
      ds.stat_hash[:entries] ? ds.stat_hash[:entries] += 1 : ds.stat_hash[:entries] = 1
      ds.stat_hash[site] ? ds.stat_hash[site] += won_lost : ds.stat_hash[site] = won_lost
      ds.stat_hash[sport] ? ds.stat_hash[sport] += won_lost : ds.stat_hash[sport] = won_lost
      ds.stat_hash[type] ? ds.stat_hash[type] += won_lost : ds.stat_hash[type] = won_lost
      ds.stat_hash[[site,type]] ? ds.stat_hash[[site,type]] += won_lost : ds.stat_hash[[site,type]] = won_lost
      ds.stat_hash[[site,sport]] ? ds.stat_hash[[site,sport]] += won_lost : ds.stat_hash[[site,sport]] = won_lost
      ds.stat_hash[[sport,type]] ? ds.stat_hash[[sport,type]] += won_lost : ds.stat_hash[[sport,type]] = won_lost
      ds.stat_hash[[site,sport,type]] ? ds.stat_hash[[site,sport,type]] += won_lost : ds.stat_hash[[site,sport,type]] = won_lost
      ds.save!
      e.update! aggregated_for_user: true
      puts "updated #{e.id}"
    end

  end

end
