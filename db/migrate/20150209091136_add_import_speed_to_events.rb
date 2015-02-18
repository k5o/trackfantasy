class AddImportSpeedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :imports_per_sec, :float
  end
end
