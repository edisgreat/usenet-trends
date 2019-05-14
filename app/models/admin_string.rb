# == Schema Information
#
# Table name: admin_strings
#
#  id         :bigint(8)        not null, primary key
#  cookie     :text
#  authstring :text
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AdminString < ApplicationRecord

  scope :error, -> { where(status: -1) }
  scope :best, -> { where(status: 0).order('updated_at desc') }

  def status_map
    {
      -1 => :error,
      0 => :new,
    }
  end

  def status_s
    status_map[status]
  end

end
