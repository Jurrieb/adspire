class User < ActiveRecord::Base

  has_and_belongs_to_many :roles, :join_table => :users_roles
  has_many :sites

  accepts_nested_attributes_for :sites, :allow_destroy => true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles, :name, :lastname, :phone, :country, :organisation, :comment, :sites_attributes
  
  def role?(role) 

    if self.roles.find_by_name(role) 
        return true
    end

  end 
end