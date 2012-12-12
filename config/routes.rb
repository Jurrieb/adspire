Datafeeds::Application.routes.draw do

  root :to => "pages#dashboard"

  get "leads/index"

  get "leads/show"

  get "leads/edit"

  get "leads/update"

  match "/clicks" => 'clicks#create'


  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
  }

  resources :sites, :only => [:index, :edit, :update]

  resources :categories

  resources :feeds do
    collection do
      match "/own" => 'feeds#index_own'
      match "/fields/:id" => 'feeds#fields'
      match "/categories/:id" => 'feeds#categories'
      post 'update_fields'
      match '/filter' => 'feeds#filter'
    end
    resources :products
  end 


  resources :products do
    collection do
      match "/export" => 'products#export'
    end
  end
end
