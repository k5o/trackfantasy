class ResetPasswordController < ApplicationController
  before_filter :no_layout
  before_filter :find_user, only: [:show, :update]

  def new
  end

  def show
    redirect_to root_path unless @user
  end

  def update
    if @user && @user.update_attributes(reset_params)
      @user.clear_reset_password_token!
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      render :show
    end
  end

  def create
    user = User.find_by_email(params[:email])

    if user
      user.generate_reset_password_token!
      UserMailer.reset_password_email(user).deliver_later
    end

    flash[:success] = "Thanks! Please check your email (#{params[:email]}) and follow the link to reset your password."
    redirect_to new_reset_password_path
  end

  private

  def find_user
    @user = User.find_by_reset_password_token(params[:id])
  end

  def reset_params
    params[:user].permit(:password, :reset_password_token)
  end
end