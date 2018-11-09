class ResponseCompleteMailer < ApplicationMailer
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def success request

    @request = request
    email = request.author_email
    if email =~ VALID_EMAIL_REGEX
      mail(to: email, subject: 'Your Usenet Trends Request is complete')
    end

  end
end
