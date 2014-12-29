class CreateDateStats < ActiveRecord::Migration
  def change
    create_table :date_stats do |t|
      t.references :user
      t.date :date
      t.json :stat_hash, default: {}
    end
  end
end
