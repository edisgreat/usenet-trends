json.extract! result, :id, :start_date, :end_date, :amount, :precision, :status, :created_at, :updated_at
json.url result_url(result, format: :json)
