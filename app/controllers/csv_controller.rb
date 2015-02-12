class CsvController < ApplicationController
  before_filter :authorize!

  def upload
    # Check for file presence AND handle dropzone submission (normal form submission won't have any files attached)
    files = params[:file]
    store_event!(Event::CSV_IMPORT)

    if files
      files.each_pair do |file_index, file|
        filename = "#{@user_id}-#{file_index}-#{file.original_filename}"
        contents = file.read

        File.open("#{Rails.root.to_s}/tmp/#{filename}", 'wb') do |f|
          f.write contents
        end

        if filename.include?("fanduel")
          FanduelCsvImporterJob.perform_now({filename: filename, user: @user_id})
        elsif filename.include?("draftkings")
          byebug
          DraftkingsCsvImporterJob.perform_now({filename: filename, user: @user_id})
        end
      end

      render nothing: true, status: 200 and return
    end

    flash[:success] = "Your entries are being processed, try refreshing in a minute."
    redirect_to dashboard_path
  end

  def authorize!
    begin
      verify_authenticity_token
      @user_id = request.headers["HTTP_USER_ID"]
    rescue
      render nothing: true, status: 403 and return
    end
  end
end
