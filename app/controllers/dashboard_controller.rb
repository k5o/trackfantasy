class DashboardController < ApplicationController
  before_filter :verify_user
  caches_action :fetch_dashboard_data # TODO: invalidate cache when new csv is imported

  def index
  end

  def fetch_dashboard_data
    # Asychronously load this data on page ready
    # TODO: Ensure request/return are clean, email notify admins if not (exception email)
    date_range = params[:from_date]..params[:to_date]
    site = params[:site]

    @analytics = Dashboard::AnalyticsCalculator.new(@user, date_range, site)

    render 'presenter.js'
  end

  private

  def verify_user
    redirect_to root_path unless current_user && !current_user.uninitiated?

    @user = current_user
  end
end