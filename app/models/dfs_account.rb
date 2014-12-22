class DfsAccount < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  belongs_to :opponent_dfs_account, class_name: "User", foreign_key: "user_id"

  has_many :entries

  def has_username?
    username
  end

end
