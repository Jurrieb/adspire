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

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :name, :lastname, :phone, :country, 
                  :organisation, :comment, :street, :housenumber, :zip, :place, :btw, :kvk, :company_name, 
                  :sites_attributes, :notice_attributes
  
  # Validation rules voor login
  validates :email, :uniqueness => true
  validates :password, :confirmation => true, :length => { :maximum => 32 }
  validates :password_confirmation, :presence => true, :length => { :minimum => 32 }  

  # Validation rules for profile
  validates :name, :presence => true, :on => :update
  validates :lastname, :presence => true, :on => :update
  validates :phone, :presence => true, :length => { :minimum => 8, :maximum => 13}
  validates :country, :presence => true, :on => :update
  validates :street, :presence => true, :on => :update
  validates :housenumber, :presence => true
  validates :zip, :presence => true

  # Validation rules for organisation

  validates :company_name, :presence => true

  validates_format_of :btw, :with => URI::regexp(%w([A-Za-z]{2}d{9}[A-Za-z]d{2}))
  validates :kvk, :numericality => { :only_integer => true, :length => { :maximum   => 10 } }
  # Validation rules for sites
  validates_format_of :url, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

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