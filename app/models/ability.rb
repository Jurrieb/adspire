class Ability  
  include CanCan::Ability  
  
  def initialize(user)  
    
  	unless user
  		user = User.new
  	end

    if user.role? :admin  
      can :manage, :all  
    else  
      can :read, :all  
    end  
  end  
end  