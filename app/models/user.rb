class User < ActiveRecord::Base

  before_create :edit_role
  after_create :add_notices
  
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

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :name, :lastname, :phone, :organisation, :comment, 
                  :street, :housenumber, :zip, :place, :btw, :kvk, :company_name, 
                  :sites_attributes, :notice_attributes
  
  # Validation rules voor login
  validates :email, :uniqueness => true
  validates :password, :confirmation => true, :length => { :maximum => 32 }, :on => :create
  validates :password_confirmation, :presence => true, :length => { :maximum => 32 }, :on => :create  

  # Validation rules for profile
  validates :name, :presence => true, :on => :update
  validates :lastname, :presence => true, :on => :update
  validates :phone, :presence => true, :length => { :minimum => 8, :maximum => 13}, :numericality => true, :on => :update
  validates :street, :presence => true, :on => :update
  validates :housenumber, :presence => true, :numericality => true, :on => :update
  validates :zip, :presence => true, :format => /^[0-9]{4}\s*[a-zA-Z]{2}/x, :on => :update
  validates :place, :presence => true, :on => :update

  # Validation rules for organisation
  with_options :if => :business? do |t|
    t.validates :company_name, :presence => true
    t.validates :btw, :presence => true, :format => URI::regexp(%w([A-Za-z]{2}d{9}[A-Za-z]d{2}))
    t.validates :kvk, :numericality => { :only_integer => true, :length => { :maximum   => 10 } }
  end

  # See if user has a business
  def business?
    business = self.organisation.to_s
    if business == "business"
      return true
    else
      return false
    end
  end

  # Add user notices
  def add_notices
    @notice = Notice.new
    @notice.user_id = self.id
    @notice.save
  end

  # Get role name
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