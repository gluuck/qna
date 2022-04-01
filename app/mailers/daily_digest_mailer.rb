class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = 'hi'

    mail to: user.email
  end
end
