class Notice < ActiveRecord::Base
  
  belongs_to :user

  attr_accessible :lead, :sale, :feed, :result, :status, :merchant, :action, :user_id

  #validates :lead, :inclusion => {:in => [true, false]}
  #validates :sale, :inclusion => {:in => [true, false]}
  #validates :feed, :inclusion => {:in => [true, false]}
  #validates :result, :inclusion => {:in => [true, false]}
  #validates :status, :inclusion => {:in => [true, false]}
  #validates :merchant, :inclusion => {:in => [true, false]}
  #validates :action, :inclusion => {:in => [true, false]}

  

end