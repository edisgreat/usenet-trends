class Result < ApplicationRecord
  belongs_to :request

  # status -1 = error
  # status 0 = untouched
  # status 1 = processing
  # status 2 = done

  default_scope { order(id: :asc) }

  def amount_per_day
    if precision == 'month'
      (amount / 30.0).to_f.round(3)
    end
  end



end
