class CreateEventsTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.references :user
      t.string :ip_address
      t.string :browser
      t.string :browser_version
      t.string :platform
      t.timestamps
    end
  end
end
