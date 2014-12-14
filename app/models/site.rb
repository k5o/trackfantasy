class Site < ActiveRecord::Base
  has_many :dfs_accounts
  has_many :contests
  
end
