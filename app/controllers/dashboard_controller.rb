class DashboardController < ApplicationController
  before_filter :verify_user
  before_filter :load_params
  # caches_action :fetch_dashboard_data, expires_in: 1.month # TODO: invalidate cache when new csv is imported

  def index
    @is_new_user = @user.entries.blank?
  end

  def fetch_dashboard_data
    # TODO: Ensure request/return are clean, email notify admins if not (exception email)
    @analytics = Dashboard::AnalyticsCalculator.new(@user, @date_range, @site, @sport)

    if @analytics.valid?
      if request.xhr?
        render partial: 'presenter', status: 200 and return
      else
        redirect_to dashboard_path(from_date: @date_range.first, to_date: @date_range.last, site: @site, sport: @sport)
      end
    else
      flash.now[:error] = "Something went wrong, please make sure your date input is valid. <a href='/dashboard'>Refresh</a>".html_safe
      render :index, status: 403 and return
    end
  end

  def games
    @sports_played = current_user.sports_played

    @sport = @sports_played.length == 1 ? @sports_played.first : params[:sport]
  end

  def fetch_games_data
  end

  def import
  end

  def contact
  end

  def user_feedback
    message = params[:user_feedback]

    UserMailer.user_feedback_email(current_user, message).deliver_later if message.present?

    flash[:success] = "Feedback sent, thank you!"
    redirect_to contact_path
  end

  private

  def verify_user
    @user = current_user
  end

  def load_params
    @date_range = params[:from_date]..params[:to_date]
    @site = params[:site]
    @sport = params[:sport]
  end
end