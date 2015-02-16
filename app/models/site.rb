class Site < ActiveRecord::Base
  NAMES = ['fanduel', 'draftkings']

  has_many :accounts
  has_many :contests
  has_many :entries
  has_many :import_times

  def self.fanduel_site_id
    @fanduel_site_id ||= Site.find_by_name("fanduel").try(:id)
  end
end
