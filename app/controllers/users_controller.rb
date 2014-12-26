class UsersController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  before_filter :parse_plan, only: [:new, :create]
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

  private

  def user_params
    params.permit(:email, :password)
  end
end