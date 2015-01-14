class UserMailer < ActionMailer::Base
  default from: "\"TrackFantasy Support\" <support@trackfantasy.com>"

  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'TrackFantasy Reset Password Instructions', bcc: "support@trackfantasy.com")
  end
end