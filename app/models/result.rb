class Result < ApplicationRecord
  belongs_to :request

  # status -1 = error
  # status 0 = untouched
  # status 1 = processing
  # status 2 = done

end
