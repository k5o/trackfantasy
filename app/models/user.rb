class User < ActiveRecord::Base

  has_many :dfs_accounts
  has_many :entries
end
