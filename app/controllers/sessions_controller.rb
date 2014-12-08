class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash.now[:error] = "Invalid username/email or password combination"
      render :new
    end
  end

  def destroy
    reset_session
    flash[:success] = "Signed out successfully!"
    redirect_to root_path
  end
end