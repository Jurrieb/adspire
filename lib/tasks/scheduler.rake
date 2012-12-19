namespace :scheduler do
  desc "TODO"
  task :parse => :environment do
	feed = Feed.find(:first, :conditions => {:status => 'active'})
	feed.last_parse = Datetime.now
	feed.save
	feed.delay.parse_feed
  end

end
