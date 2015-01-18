class ExceptionMailer < ActionMailer::Base
  default from: "\"TrackFantasy Support\" <support@trackfantasy.com>"

  def csv_import_errors_email(errors)
    @errors = errors
    mail(to: "support@trackfantasy.com", subject: "#{@errors.count} errors happened :(")
  end

end
