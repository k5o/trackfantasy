class CsvController < ApplicationController

  def upload
    if params[:file]
      filename = params[:file].original_filename
      tmp_file = "#{Rails.root}/tmp/uploaded.csv"
      id = 0
      while File.exists?(tmp_file) do
        tmp_file = "#{Rails.root}/tmp/#{filename}_uploaded-#{id}.csv"
        id += 1
      end
      File.open(tmp_file, 'wb') do |f|
        f.write params[:file].read
      end
      if filename.include?("fanduel")
        FanduelCsvImporterJob.perform_later({file_location: tmp_file, user: current_user.id})
      elsif filename.include?("draftkings")
        DraftkingsCsvImporterJob.perform_later({file_location: tmp_file, user: current_user.id})
      end
    end

    flash[:success] = "Your entries are being processed, try refreshing in a minute."
    redirect_to dashboard_path
  end
end
