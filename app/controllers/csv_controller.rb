class CsvController < ApplicationController
  require 'active_job'
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
        FanduelCsvImporterJob.new.perform({file_location: tmp_file, user: current_user})
      elsif filename.include?("draftkings")
        DraftkingsCsvImporterJob.new.perform({file_location: tmp_file, user: current_user})
      end
    end
    redirect_to dashboard_path
  end
end
