FactoryBot.define do
  
  factory :request do
    start_date {"1985-01-01"}
    end_date {"1986-01-01"}
    query {"stallman"}
    cookie {"blah"}
    authstring {"blah"}
    author_email {"test@example.com"}
    author_name {"Anon"}
    status {0}
  end

  factory :result do
    start_date {"1985-01-01"}
    end_date {"1986-01-01"}
    amount {5}
    precision {"month"}
    request
    status {0}
  end

end