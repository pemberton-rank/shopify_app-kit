task :kit => :environment do
  puts "#{Time.now.getutc} Sending kit converstaions..."
  logger = ShopifyApp::Kit.config.rake_task_logger

  service = KitOfferJob.new(logger)
  service.send_all

  puts "#{Time.now.getutc} Sent kit offers."
end
