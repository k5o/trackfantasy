class Site < ActiveRecord::Base
  has_many :accounts
  has_many :contests
  
end
