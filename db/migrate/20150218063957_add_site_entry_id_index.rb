class AddSiteEntryIdIndex < ActiveRecord::Migration
  def change
    add_index :entries, :site_entry_id, unique: true
  end
end
