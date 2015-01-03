class UsersController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  before_filter :parse_plan, only: [:new, :create]
  before_filter :load_user, only: [:edit, :update]

  def show
  end

  def new
    redirect_to new_payment_path(plan: params[:plan]) and return if current_user && current_user.uninitiated?
    redirect_to root_path and return if current_user

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to new_payment_path(plan: params[:plan])
    else
      render :new
    end
  end

  def edit
  end

  def update
    new_password = params[:new_password]

    if new_password.present?
      if current_user.password == params[:current_password]
        current_user.password = new_password
        current_user.save
      else
        flash.now[:error] = 'Your current password was incorrect.'
        render :edit and return
      end
    end

    stripe_token = params[:stripeToken]

    if stripe_token.present?
      cu = Stripe::Customer.retrieve(current_user.stripe_customer_id)
      cu.card = stripe_token
      begin
        cu.save
      rescue
        flash.now[:error] = 'Something went wrong in saving your card details. Please try again.'
        render :edit and return
      end
    end

    flash[:success] = 'Your account has been updated.'
    redirect_to account_path and return
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def load_user
    @user = current_user
    @stripe_details = Stripe::Customer.retrieve(@user.stripe_customer_id)
  end
end