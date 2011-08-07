class Notifier < ActionMailer::Base
  default :from => "gregory.mostizky@gmail.com"

  def welcome_email(url, to = 'gregory.mostizky@kontera.com', subject = 'Layer Preview')
    @url = url
    mail(:to => to, :subject => subject)
  end

end
