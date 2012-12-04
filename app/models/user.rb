class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles

  # DO comment when migrating
  ROLES = Role.all 
  
  def roles=(roles)  
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum  
  end  
  
  def roles  
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }  
  end  
  
  def role?(role)  
    roles.include? role.to_s  
  end  
end