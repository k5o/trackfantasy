class CsvController < ApplicationController
  before_filter :authorize!

  def upload
    # Check for file presence AND handle dropzone submission (normal form submission won't have any files attached)
    files = params[:file]

    if files
      event = store_event!(Event::CSV_IMPORT)

      files.each_pair do |file_index, file|
        filename = "#{@user_id}-#{event.id}-#{file_index}-#{file.original_filename}"
        full_path = "#{Constants::TEMP_PATH}#{filename}"
        contents = file.read

        File.open(full_path, 'wb') do |f|
          f.write contents
        end

        if filename.include?("fanduel")
          FanduelCsvImporterJob.perform_later({filename: filename, user: @user_id, event: event.id})
        elsif filename.include?("draftkings")
          DraftkingsCsvImporterJob.perform_later({filename: filename, user: @user_id, event: event.id})
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
