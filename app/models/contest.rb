class Contest < ActiveRecord::Base
  belongs_to :site
  has_many :entries
end
