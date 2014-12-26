class SessionsController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  def new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id

      if @user.uninitiated?
        redirect_to new_payment_path and return
      else
        redirect_to dashboard_path and return
      end
    else
      flash.now[:error] = "Invalid username/email or password combination"
      render :new
    end
  end

  def destroy
    reset_session
    flash[:success] = "Signed out successfully."
    redirect_to root_path
  end
end