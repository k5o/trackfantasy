class AddAggregatedForUserToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :aggregated_for_user, :boolean, default: false
  end
end
