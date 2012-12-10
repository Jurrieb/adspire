class User < ActiveRecord::Base

  before_create :edit_role

  # Relations
  has_and_belongs_to_many :roles, :join_table => :users_roles
  has_many :sites
  has_one :notice

  accepts_nested_attributes_for :sites, :allow_destroy => true
  accepts_nested_attributes_for :notice, :allow_destroy => true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :name, :lastname, :phone, :country, :organisation, :comment, :street, :housenumber, :zip, :place, :btw, :kvk, :company_name, :notification_lead, :notification_sale, :notification_feed, :notification_result, :notification_status, :notification_merchant, :sites_attributes, :notice_attributes
  
  # Validation rules voor login
  validates :email, :uniqueness => true
  validates :password, :confirmation => true, :length => { :maximum => 32 }
  validates :password_confirmation, :presence => true, :length => { :minimum => 32 }  

  # Validation rules for profile


  # Validation rules for organisation
  validates_format_of :btw, :with => URI::regexp(%w([A-Za-z]{2}d{9}[A-Za-z]d{2}))
  validates_format_of :kvk, :with => URI::regexp(%w(\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))))

  # Validation rules for sites
  validates_format_of :url, :with => URI::regexp(%w(\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))))

  # Validation rules for Notifications



  def role?(role) 

    if self.roles.find_by_name(role) 
        return true
    end

  end

  # Default role = user
  def edit_role 
    if self.roles.blank?
      self.roles << Role.find_by_name('user') 
    end
  end
end