class ResponseCompleteMailer < ApplicationMailer
  def success

    mail(to: 'ed.jburnett@gmail.com', subject: 'Your Usenet Trends Request is complete and is a success')


  end
end
