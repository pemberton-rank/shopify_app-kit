task :kit => :environment do
  puts "#{Time.now.getutc} Sending kit converstaions..."
  logger = ShopifyApp::Kit.config.rake_task_logger

  service = KitOfferJob.new(logger)
  one_done = true
  while one_done
    one_done = service.send_one
  end

  puts "#{Time.now.getutc} Sent kit offers."
end
