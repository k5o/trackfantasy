class InitialMigrations < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :stripe_customer_id
      t.string :password_digest, null: false
      t.date :active_until
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
      t.integer :entrants, :max_entrants, :buy_in_in_cents, :total_prizes_paid_in_cents
      t.decimal :average_score
      t.string :sport, :title, :game_type, :link, :site_contest_id
      t.date :completed_on
      t.timestamps
    end

    create_table :entries do |t|
      t.references :contest, :account, :user
      t.integer :position, :opponent_account_id, :winnings_in_cents
      t.integer :entry_fee_in_cents, :profit, null: false
      t.decimal :score, null: false
      t.string :site_entry_id, :opponent_username, :link, :sport
      t.date :entered_on
      t.timestamps
    end

    create_table :payment_plans do |t|
      t.string :name, null: false
      t.integer :amount_in_cents, null: false
      t.string :interval, null: false
      t.integer :interval_count, default: 1
      t.timestamps
    end

    PaymentPlan.create(name: 'monthly', amount_in_cents: 1900, interval: 'month', interval_count: 1)
    PaymentPlan.create(name: 'annual', amount_in_cents: 17900, interval: 'year', interval_count: 1)

  end

end
