class AddEnteredOnToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entered_on, :date
  end
end
