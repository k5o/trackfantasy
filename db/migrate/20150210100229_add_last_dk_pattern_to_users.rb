class AddLastDkPatternToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_dk_pattern, :string, array: true, default: '{}'
  end
end
