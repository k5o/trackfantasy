class CsvController < ApplicationController

  def upload
    # Check for file presence AND handle dropzone submission (normal form submission won't have any files attached)
    if params[:file]
      filename = params[:file].original_filename
      if filename.include?("fanduel")
        FanduelCsvImporterJob.perform_later({file_contents: params[:file].read, user: current_user.id})
      elsif filename.include?("draftkings")
        DraftkingsCsvImporterJob.perform_later({file_contents: params[:file].read, user: current_user.id})
      end

      render nothing: true, status: 200 and return
    end

    flash[:success] = "Your entries are being processed, try refreshing in a minute."
    redirect_to dashboard_path
  end
end
