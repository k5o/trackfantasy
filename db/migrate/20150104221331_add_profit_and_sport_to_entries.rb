class AddProfitAndSportToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :profit, :decimal, index: true
    add_column :entries, :sport, :string, index: true
  end
end
