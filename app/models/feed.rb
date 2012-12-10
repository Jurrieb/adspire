class Feed < ActiveRecord::Base
  attr_accessible :name, :url, :xml_path, :feed_path, :interval_in_seconds, :last_parse
  has_many :products, :dependent => :delete_all
  has_many :datafeed_keys, :dependent => :delete_all
  has_many :foreign_categories, :dependent => :delete_all

  validates :name, :presence => true
  validates :interval_in_seconds, :presence => true
end
