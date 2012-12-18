Datafeeds::Application.routes.draw do

  root :to => "pages#dashboard"

  get "leads/index"

  get "leads/show"

  get "leads/edit"

  get "leads/update"

  match "/clicks" => 'clicks#create'

  post "/notifications/settings_update"


  devise_for :users, :controllers => { 
    :registrations => "users/registrations",
  }

  resources :sites

  resources :feeds do
    collection do
      match "/own" => 'feeds#own_feeds'
      get "/fields/:id" => 'feeds#fields'
      put "/fields/:id" => 'feeds#update_fields'
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


  get "notifications/settings"
  put "notifications/settings_update"

  namespace :admin do
      resources :users
  end

end