# == Schema Information
#
# Table name: requests
#
#  id           :bigint(8)        not null, primary key
#  start_date   :date
#  end_date     :date
#  query        :string
#  cookie       :string
#  author_email :string
#  author_name  :string
#  source_type  :string
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  authstring   :string
#

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
    if(end_date > '2002-01-01'.to_date)
      errors.add(:end_date, "Cannot be after 2002")
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

  #
  # Callback after create
  # Loop through, make monthly Result with status: waiting
  # result_sweeper_job.rb will pick up waiting Results and populate with data
  #
  def create_results
    loop_start_date = start_date.at_beginning_of_month
    loop_end_date = end_date.at_beginning_of_month

    while loop_start_date < loop_end_date
      result_start_date = loop_start_date
      result_end_date = loop_start_date.next_month
      
      results.create(start_date: result_start_date, end_date: result_end_date, amount: 0, precision: 'month', status: 0)

      loop_start_date = result_end_date
    end
  end

  # Used by _result-graph.html.erb
  # Outputs array of results
  def display_graph_results
    result_length = results.length
    last_result_amount = nil
    return_array = []
    results.order(start_date: :asc).each_with_index do |result, i|
      last_result_amount = result.amount
      return_array << result
    end
    return_array
  end

  def display_list_results
    results.order(start_date: :asc)
  end


end
