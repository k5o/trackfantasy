class CreatePaymentPlans < ActiveRecord::Migration
  def change
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
