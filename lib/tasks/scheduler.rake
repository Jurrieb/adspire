require 'delayed_job_active_record'
namespace :scheduler do
  desc "TODO"
  task :parse => :environment do
	feed = Feed.find(:first, :conditions => {:status => 'active'})
	if feed
		feed.delay.parse_feed
	end
  end

end
