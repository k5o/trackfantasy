class PaymentsController < ApplicationController
  before_filter :auth_user
  before_filter :parse_plan
  before_filter :no_layout

  def new
    @plan = params[:plan]
  end

  def create
    @payment_plan = PaymentPlan.find_by_name(@plan)

    render :new unless @payment_plan

    begin
      customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:token],
        plan: @payment_plan.name
      )
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_payment_path(@plan) and return
    end

    current_user.stripe_customer_id = customer.id
    current_user.activate!
    current_user.set_active_until(@plan)!

    # redirect_to root_path
  end

  private

  def auth_user
    redirect_to root_path unless current_user
    redirect_to dashboard_path if current_user.active?
  end
end
