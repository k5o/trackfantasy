class InitialMigrations < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :email
      t.timestamps
    end

    create_table :accounts do |t|
      t.references :user, :site
      t.string :username
      t.integer :site_user_id
      t.timestamps
    end

    create_table :sites do |t|
      t.string :name, :domain
      t.timestamps
    end

    create_table :contests do |t|
      t.references :site
      t.integer :entrants, :max_entrants
      t.decimal :average_score, :buy_in, :total_prizes_paid
      t.string :sport, :title, :game_type, :link, :site_contest_id
      t.date :completed_on
      t.timestamps
    end

    create_table :entries do |t|
      t.references :contest, :account
      t.integer :position, :opponent_account_id
      t.decimal :score, :entry_fee, :winnings
      t.string :site_entry_id, :opponent_username, :link
      t.timestamps
    end
  end

end
