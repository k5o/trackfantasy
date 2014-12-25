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

    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:token],
      plan: @payment_plan.name
    )

    current_user.stripe_customer_id = customer.id
    current_user.activate!

    # rescue Stripe::CardError => e
    #   flash[:error] = e.message
    #   redirect_to new_payment_path(@plan)
    # end

    # redirect_to root_path
  end

  private

  def auth_user
    redirect_to root_path unless current_user
  end
end
