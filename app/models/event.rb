class Event < ActiveRecord::Base
  CSV_IMPORT = "CSV Import"
  WIPE = "Wipe Entries"

  belongs_to :user
end