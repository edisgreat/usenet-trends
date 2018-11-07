require 'curb'
require 'json'

class ResultSweeperJob < ApplicationJob
  queue_as :default

  def perform
    results = Result.where(status: 0, precision: 'month')
    result_array = results.to_a # Cause Rals is weird
    results.update_all status: 1 # mark all as owned
    result_array.each do |result|
      result.request.update status: 1
      amount = count_result result
      if !amount
        puts "!amount"
        result.update status: -1
      end
        result.update amount: amount, status: 2
        check_complete_request result.request
        sleep 0.5
    end
    
  end

  def check_complete_request request
    unless request.results.any?{|result| result.status != 2}
      request.update status: 2
    end
  end

  def count_result result
    url = 'https://groups.google.com/forum/fsearch?appversion=1&hl=en&authuser=0'
    query = "\"#{result.request.query}\" after:#{result.start_date.to_s} before:#{result.end_date.to_s}"
    authtoken = "D2FD55322ACD18E1E5E0D2074EB623A5"
    cookie = 'SID=pAbQ9LdAK3-qrAa-cYqeBsfFEHn4SQQAja3PW2omQN1-e0lIAd7cZXFwsb9vP17Ux8S_Lg.; HSID=AvXcvfdhGPSkIqn7j; SSID=AZomMg28PhUtN5gec;'
    #query = 'wozniak after:1985-06-10 before:1985-06-11'
    payload = "7|3|12|https://groups.google.com/forum/|#{authtoken}|5m|APQx5HQQ9veQwOXO9XCv5HHCQOMjTKaJhw:1541601562709|_|getMatchingMessages|5t|i|I|1u|5n|#{query}|1|2|3|4|5|6|6|7|8|9|9|10|11|12|0|0|20|0|0|"

    post = Curl.post(url, payload) do |curl|
      curl.headers['Content-Type'] = 'text/x-gwt-rpc; charset=utf-8'
      curl.headers['X-GWT-Permutation'] = 'fdsds'
      curl.headers['X-GWT-Module-Base'] = 'https://groups.google.com/forum/'
      curl.headers['Cookie'] = cookie
    end
    output = post.body_str
    if output.first(4) == '//OK'
      output.slice!(0,4)
      output = output.tr("'", '"')
      # TODO Add error handling here
      output_array = JSON.parse(output)
      # Because the google groups output has a second array in here
      output_array.each do |value|
        if value.class==Array
          array_length = value.length
          amount = amount_from_google_groups_length array_length
          return amount
        end
      end
    else
      return false
    end
  end


  def amount_from_google_groups_length array_length
    if array_length <= 4
      0
    else
      ((array_length - 23) / 7).to_i
    end
  end

end
