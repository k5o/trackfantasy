class ImportTime < ActiveRecord::Base
  belongs_to :event
  belongs_to :site
end