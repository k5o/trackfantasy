class DashboardController < ApplicationController
  before_filter :verify_user
  before_filter :load_params
  # caches_action :fetch_dashboard_data, expires_in: 1.month # TODO: invalidate cache when new csv is imported

  def index
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
      flash.now[:error] = "Something went wrong, please make sure your date input is valid. <a href=\"#{dashboard_path}\">Refresh</a>".html_safe
      render :index, status: 403 and return
    end
  end

  def games
    @sports_played = current_user.sports_played

    @sport = @sports_played.length == 1 ? @sports_played.first : params[:sport]

    @games = Dashboard::Games.new(view_context)

    # data = current_user.entries.where(sport: 'nba').group(:game_type, :entry_fee_in_cents).order(:entry_fee_in_cents).select(<<-SQL)
    #   game_type, entry_fee_in_cents,
    #   count(*) as count,
    #   sum(profit) / 100.0 as profit,
    #   sum(profit) / 100.0 / nullif((sum(entry_fee_in_cents) / 100.0), 0) as roi,
    #   sum(CASE profit > 0 when true then 1 else 0 end) / count(*) as winrate,
    #   avg(score)::float8 as score
    # SQL

    # @data = data.to_json
  end

  def fetch_games_data


    @games = Dashboard::Games.new(view_context)
    render json: @games, status: 200

    # if @games.valid?
    #   if request.xhr?
    #     render json: @games
    #   else
    #     redirect_to dashboard_path(from_date: @date_range.first, to_date: @date_range.last, site: @site, sport: @sport)
    #   end
    # else
    #   flash.now[:error] = "Something went wrong, please make sure your date input is valid. <a href='/dashboard'>Refresh</a>".html_safe
    #   render :index, status: 403 and return
    # end
  end

  def import
    last_import_date
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
    @is_new_user = @user.empty_entries?

    redirect_to root_path unless @user
  end

  def load_params
    @date_range = params[:from_date]..params[:to_date]
    @site = params[:site]
    @sport = params[:sport]
  end

  def last_import_date
    unless @is_new_user
      @last_import_date = @user.entries.last.created_at
    end
  end
end
