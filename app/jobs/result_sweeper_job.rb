require 'curb'
require 'json'

class ResultSweeperJob < ApplicationJob
  queue_as :default

  def perform
    results = Result.for_sweep.limit(20)
    logger.info "ResultSweeperJob-perform: found #{results.length} results"
    result_array = results.to_a # Cause Rails is weird

    # Mark all as owned and do work on each
    results.update_all status: 1 
    result_array.each do |result|
      result.request.update status: 1

      # utilize response from google
      body_str = get_googlegroups_body result
      result.update debug_result: body_str
      amount = calc_googlegroups_body body_str

      if !amount
        logger.debug "ResultSweeperJob-error: bad value received: #{body_str}"
        result.update status: -1
      elsif amount >= 19 && result.precision == 'month'
        logger.debug "creating daily from #{result.request.query}, #{result.start_date} - #{result.end_date}"
        create_daily_requests result
      else
        if result.precision == 'day'
          result_month = Result.find(result.result_month_id)
          result_month.update amount: (amount+result_month.amount)
        end
        result.update amount: amount, status: 2
        logger.info "found #{amount} from #{result.request.query}, #{result.start_date} - #{result.end_date}"
        check_complete_request result.request
        sleep 0.1
      end
    end
  end

  def create_daily_requests result
    request = result.request

    loop_start_date = result.start_date
    loop_end_date = result.end_date

    while loop_start_date < loop_end_date
      result_start_date = loop_start_date
      result_end_date = loop_start_date.next_day
      request.results.create(start_date: result_start_date, end_date: result_end_date, amount: 0, precision: 'day', status: 0, result_month_id: result.id)
      loop_start_date = result_end_date
    end
    result.update status: 3
  end


  def check_complete_request request
    unless request.results.any?{|result| result.status != 2}
      request.update status: 2
      ResponseCompleteMailer.success(request).deliver_now
    end
  end

  # Use curb gem to grab weird Googlegroups API endpoint
  def get_googlegroups_body x_result
    x_request = x_result.request
    url = 'https://groups.google.com/forum/fsearch?appversion=1&hl=en&authuser=0'
    query = "#{x_request.query} after:#{x_result.start_date.to_s} before:#{x_result.end_date.to_s}"
    cookie = x_request.cookie
    authstring = x_request.authstring

    if authstring.blank?
      if as = AdminString.best.first
        authstring = as.authstring 
      end
    end

    if cookie.blank?
      if as = AdminString.best.first
        cookie = as.cookie 
      end
    end

    payload = "7|3|12|https://groups.google.com/forum/|#{authstring}|_|getMatchingMessages|5t|i|I|1u|5n|#{query}|1|2|3|4|5|6|6|7|8|9|9|10|11|12|0|0|20|0|0|"
    x_result.update debug_payload: payload
    post = call_googlegroups url, payload, cookie

    post.body_str
  end

  def call_googlegroups url, payload, cookie
    logger.debug "calling #{url} with payload #{payload} and cookie #{cookie}"
    Curl.post(url, payload) do |curl|
      curl.headers['Content-Type'] = 'text/x-gwt-rpc; charset=utf-8'
      curl.headers['X-GWT-Permutation'] = 'fdsdsfdsfds'
      curl.headers['X-GWT-Module-Base'] = 'https://groups.google.com/forum/'
      curl.headers['Host'] = 'groups.google.com'
      curl.headers['Cookie'] = cookie
      curl.headers['User-Agent'] = "UsenetTrends"
      curl.headers['Accept'] = "*/*"
      curl.headers['Cache-Control'] = "no-cache"
      curl.headers['Connection'] = "keep-alive"
    end
  end


  # Check output. 
  # If its OK Then parse and return amount
  #  Else theres an error with the cookie probably, so return false
  def calc_googlegroups_body body_str
    logger.info "received body_str #{body_str}"

    if body_str.first(4) == '//OK'
      body_str.slice!(0,4)
      body_str = body_str.tr("'", '"')
      body_str = body_str.tr("\n", ' ')
      body_str = body_str.html_safe
      
      # handle the parse error with a false
      begin
        body_str_array = JSON.parse("#{body_str}", quirks_mode: true) # Output as string first to avoid bad potential parsing
      rescue JSON::ParserError
        logger.debug "ResultSweeperJob-error: bad parsing: #{body_str}"
        return false
      end

      # googlegroups returns a second array in the return value
      # grab it and get amount from it
      body_str_array.each do |value|
        if value.class==Array
          array_length = value.length
          amount = amount_from_google_groups_length array_length
          return amount
        end
      end
    end
    return false
  end

  def amount_from_google_groups_length array_length
    array_length = array_length.to_f
    if array_length <= 4
      0
    else
      ((array_length - 23) / 7).ceil.to_i
    end
  end

end
