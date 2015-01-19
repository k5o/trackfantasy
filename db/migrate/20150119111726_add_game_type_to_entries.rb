class AddGameTypeToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :game_type, :string
  end
end
