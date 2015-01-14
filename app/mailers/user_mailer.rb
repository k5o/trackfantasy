class UserMailer < ActionMailer::Base
  default from: "\"TrackFantasy Support\" <support@trackfantasy.com>"

  def reset_password_email(user)
    @reset_password_token = user.try(:reset_password_token) || "error-please-contact-support"
    mail(to: user.email, subject: 'TrackFantasy Reset Password Instructions', bcc: "support@trackfantasy.com")
  end

  def user_feedback_email(user, message)
    @user = user
    @message = message
    mail(to: 'support@trackfantasy.com', subject: "TrackFantasy User Feedback #{Date.today.strftime("%m/%d/%y")}")
  end
end