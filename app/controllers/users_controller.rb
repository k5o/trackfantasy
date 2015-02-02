class UsersController < ApplicationController
  before_filter :no_layout, only: [:new, :create]
  before_filter :load_user, only: [:edit, :update, :wipe_data]

  def show
  end

  def new
    redirect_to dashboard_path and return if current_user

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to import_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    new_password = params[:user][:password]

    if new_password.present?
      if current_user.authenticate(params[:user][:current_password])
        if current_user.update_attributes(user_params)
          flash[:success] = 'Password changed successfully.'
          redirect_to account_path and return
        else
          flash.now[:error] = @user.errors.full_messages.join
          render :edit and return
        end
      else
        flash.now[:error] = "Your password was incorrect."
        render :edit and return
      end
    else
      flash[:success] = 'No changes have been made.'
      redirect_to account_path and return
    end
  end

  def wipe_data
    render nothing: true, status: 403 unless @user

    store_event!(Event::WIPE)
    EntryWipeJob.perform_later(user_id: current_user.id)

    flash[:success] = 'Your entries are being deleted. This may take a while depending on the amount of entries, try refreshing in a minute.'
    redirect_to dashboard_path
  end

  private

  def user_params
    params[:user].permit(:email, :password)
  end

  def load_user
    @user = current_user
  end
end
