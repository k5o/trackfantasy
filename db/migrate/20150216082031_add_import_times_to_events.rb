class AddImportTimesToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :imports_per_sec, :float

    create_table :import_times do |t|
      t.float :rows_per_second
      t.references :event
      t.references :site
      t.timestamps
    end
  end
end
