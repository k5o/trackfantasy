class AddSalaryCapToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :salary_cap, :string
  end
end
