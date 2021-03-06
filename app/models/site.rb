class Site < ActiveRecord::Base

  belongs_to :user
  before_validation :check_url

  attr_accessible :name, :url, :description, :category_id, :active, :status, :user_id

  validates :name, :presence => true
  validates_format_of :url, :with => URI::regexp

  # Check if url has http or https prefix
  def check_url
    u = URI.parse(self.url)
	if(!u.scheme)
	    # prepend http:// and try again
	    self.url = "http://#{self.url}"
	    #Edited url
	    return self.url
	elsif(%w{http https}.include?(u.scheme))
	    #Good url
	    return self.url
	else
		#False url
		return false
	end
  end
end