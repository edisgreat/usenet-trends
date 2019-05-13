# == Schema Information
#
# Table name: results
#
#  id         :bigint(8)        not null, primary key
#  start_date :date
#  end_date   :date
#  amount     :integer
#  precision  :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  request_id :bigint(8)
#

class Result < ApplicationRecord
  belongs_to :request

  def status_map
    {
      -1 => :error,
      0 => :waiting,
      1 => :in_progress,
      2 => :complete,
      3 => :archived,
    }
  end

  scope :error, -> { where(status: -1) }
  scope :waiting, -> { where(status: 0) }
  scope :complete, -> { where(status: 2) }
  scope :month, -> { where(precision: 'month') }
  scope :day, -> { where(precision: 'day') }

  def status_s
    status_map[status]
  end

  def amount_per_day
    if precision == 'month'
      (amount / 30.0).to_f.round(3)
    elsif precision == 'day'
      amount
    end
  end


  def google_groups_link
    term = request.query.gsub('"','%22').gsub(' ','$20')
    "https://groups.google.com/forum/#!search/#{term}$20after$3A#{start_date.to_s}$20before$3A#{end_date.to_s}"
  end

end
