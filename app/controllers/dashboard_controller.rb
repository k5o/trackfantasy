class DashboardController < ApplicationController
  before_filter :verify_user
  before_filter :scope_dates

  def index
  end

  def fetch_dashboard_data
    # Asychronously load this data on page ready
    # TODO: Ensure request/return are clean, email notify admins if not (exception email)
    @analytics = AnalyticsCalculator.new(@user, @date_range)

    render json: @analytics
  end

  private

  def verify_user
    redirect_to root_path unless current_user

    @user = current_user
  end

  def scope_dates
    @date_range = nil unless params[:date]
  end
end