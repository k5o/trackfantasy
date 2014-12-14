class Entry < ActiveRecord::Base
  belongs_to :dfs_account
  belongs_to :contest

end
