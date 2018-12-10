class HomeController < ApplicationController
  def home
    ResultSweeperJob.perform_now
  end

  def envs
    r=Request.last
    ResponseCompleteMailer.success(r).deliver_now
    render html: "Temp Email Sent"
  end
end
