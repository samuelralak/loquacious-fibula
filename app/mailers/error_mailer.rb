class ErrorMailer < ApplicationMailer
  default from: "support@ak47.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_mailer.send_error.subject
  #
  def send_error(exception)
    @greeting = "Hi"
    @e = exception

    mail to: "samuelralak@hotmail.com"
  end
end
