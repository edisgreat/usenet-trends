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

  scope :error, -> { where(status: -1) }
  scope :waiting, -> { where(status: 0) }
  scope :complete, -> { where(status: 2) }

  def status_map
    {
      -1 => :error,
      0 => :waiting,
      1 => :in_progress,
      2 => :complete,
    }
  end

  def status_s
    status_map[status]
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

  def reset_results
    results.destroy_all
    create_results
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
    results.complete.order(start_date: :asc).to_a
  end

end
