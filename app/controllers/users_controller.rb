class UsersController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  def show
  end

  def new
    @plan = params[:plan]
    # TODO: Do not hardcode plan string values
    redirect_to root_path unless @plan && (@plan == 'monthly' || @plan == 'annual')

    # @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to payment_path
    else
      render :new
    end
  end

  def user_params
    params.permit(:email, :password)
  end
end