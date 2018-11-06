json.extract! request, :id, :start_date, :end_date, :query, :cookie, :author_email, :author_name, :source_type, :status, :created_at, :updated_at
json.url request_url(request, format: :json)
