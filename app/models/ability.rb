class Ability  
  include CanCan::Ability  
  
  def initialize(user)  
    
  	unless user
  		user = User.new
  	end

    if user.role? :admin  
      can :manage, :all  
    end

    if user.role? :user  
      can :dashboard, Page
      can :read, Feed
      can :read, Site
      can :create, Site
      can :update, Site, :user_id => user.id
      can [:show, :update], Site, :id => user.id
    end

    if user.role? :affiliate

    end

    if user.role? :publisher

    end
    
  end  
end  