class HomeController < ApplicationController
  def home
    
  end

  def envs
    r=Request.last
    ResponseCompleteMailer.success(r).deliver_now
    render html: "Temp Email Sent"
  end
end
