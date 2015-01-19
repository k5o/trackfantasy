class CsvController < ApplicationController

  def upload
    if params[:file]
      filename = params[:file].original_filename
      if filename.include?("fanduel")
        FanduelCsvImporterJob.perform_later({file_contents: params[:file].read, user: current_user.id})
      elsif filename.include?("draftkings")
        DraftkingsCsvImporterJob.new.perform({file_contents: params[:file].read, user: current_user.id})
      end
    end

    flash[:success] = "Your entries are being processed, try refreshing in a minute."
    redirect_to dashboard_path
  end
end
