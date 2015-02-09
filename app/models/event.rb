class Event < ActiveRecord::Base
  CSV_IMPORT = "CSV Import"
  WIPE = "Wipe Entries"

  belongs_to :user

  def store_speed!(imports)
    self.imports_per_sec = imports
    self.save!
  end
end