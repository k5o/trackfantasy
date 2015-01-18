class AddContestTitleToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :contest_title, :string
    add_column :entries, :total_entries, :integer
  end
end
