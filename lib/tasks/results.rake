namespace :results do
  desc "Look for empty results with months and find the values"
  
  task sweep: :environment do
    for i in 0..100
      ResultSweeperJob.perform_now
    end
  end


end
