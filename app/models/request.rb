class Request < ApplicationRecord
  has_many :results, dependent: :destroy
  validate :check_dates
  validate :check_strings
  before_create :set_defaults
  after_create :create_results

  def status_s
    case status
    when -1
      "Error"
    when 0
      "Waiting"
    when 1
      "In Progress"
    when 2
      "Complete"
    end
  end

  def check_dates
    if(start_date < '1981-01-01'.to_date)
      errors.add(:start_date, "Cannot be before 1981")
    end
    if(end_date > '2000-01-01'.to_date)
      errors.add(:end_date, "Cannot be after 2000")
    end
    if(end_date <= start_date)
      errors.add(:end_date, "Must be after Start Date")
    end
  end

  def check_strings
    if query.blank?
      errors.add(:query, "Cannot be empty")
    end
    if cookie.blank?
      #errors.add(:cookie, "Cannot be empty")
    end
    if authstring.blank?
      #errors.add(:authstring, "Cannot be empty")
    end
  end

  def set_defaults
    self.status = 0
    self.source_type = 'google_groups'
    if author_name.blank?
      self.author_name = "Anonymous"
    end
  end

  def create_results
    # Make monthly results
    loop_start_date = start_date.at_beginning_of_month #ensure no cheats
    loop_end_date = end_date.at_beginning_of_month

    while loop_start_date < loop_end_date
      result_start_date = loop_start_date
      result_end_date = loop_start_date.next_month
      
      results.create(start_date: result_start_date, end_date: result_end_date, amount: 0, precision: 'month', status: 0)

      loop_start_date = result_end_date
    end
  end

  # Displays 0s in opportunistic places
  def display_graph_results
    result_length = results.length
    last_result_amount = nil
    return_array = []
    results.order(start_date: :asc).each_with_index do |result, i|
      next if result.amount == 0 && last_result_amount == 0 && i != 0 && i-1 != result_length
      last_result_amount = result.amount
      return_array << result
    end
    return_array
  end

  # Removes all 0s
  def display_list_results
    results.order(start_date: :asc).select{|r| r.amount > 0}
    results.order(start_date: :asc)
  end


end
