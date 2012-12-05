class User < ActiveRecord::Base

  before_save :edit_role

  has_and_belongs_to_many :roles, :join_table => :users_roles
  has_many :sites

  accepts_nested_attributes_for :sites, :allow_destroy => true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :name, :lastname, :phone, :country, :organisation, :comment, :street, :housenumber, :zip, :place, :btw, :kvk, :company_name, :notification_lead, :notification_sale, :notification_feed, :notification_result, :notification_status, :notification_merchant, :sites_attributes
  
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