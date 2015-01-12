class RemoveStripeAndPayments < ActiveRecord::Migration
  def change
    remove_column :users, :stripe_customer_id
    remove_column :users, :active_until
    drop_table :payment_plans
  end
end
