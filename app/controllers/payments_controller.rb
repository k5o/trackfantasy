class PaymentsController < ApplicationController
  before_filter :parse_plan, only: :new

  def new
    @plan = params[:plan]
  end

  def create
    @amount = 1900

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Subscription Start: #{@amount} by #{current_user.email}",
      :currency    => 'usd'
    )

    Stripe::Plan.create(
      :amount => @amount,
      :interval => 'month',
      :name => 'Amazing Gold Plan',
      :currency => 'usd',
      :id => 'gold'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to payments_path
  end

  private

  def parse_plan
    @plan = params[:plan]
    @plan = 'monthly' unless @plan == 'monthly' || 'annual'
  end
end