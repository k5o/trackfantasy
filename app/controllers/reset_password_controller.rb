class ResetPasswordController < ApplicationController
  before_filter :no_layout
  def new
  end

  def show
  end

  def create
    user = User.find_by_email(params[:email])

    if user
      user.generate_reset_password_token!
      UserMailer.reset_password_email(user).deliver_later
      flash[:success] = "Thanks! Please check your email and follow the link to reset your password."
      redirect_to new_reset_password_path
    else
      flash.now[:error] = "No account found by that email address, please try again."
      render :new
    end
  end
end