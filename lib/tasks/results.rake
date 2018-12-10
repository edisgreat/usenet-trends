namespace :results do
  desc "Look for empty results with months and find the values"
  
  task sweep: :environment do
    ResultSweeperJob.perform_now
  end


end
