class HomeController < ApplicationController
  def home
    
  end

  def envs
    render html: ENV['sendgrid_api_key']
  end
end
