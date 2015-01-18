class AddSiteToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :site_id, :integer
  end
end
