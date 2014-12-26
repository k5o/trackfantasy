class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def no_layout
    @no_layout = true
  end

  def parse_plan
    @plan = params[:plan]
    @plan_exists = PaymentPlan::PLAN_NAMES.include?(@plan)
  end
end
