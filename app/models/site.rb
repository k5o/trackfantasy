class Site < ActiveRecord::Base
  NAMES = ['fanduel', 'draftkings']

  has_many :accounts
  has_many :contests
end
