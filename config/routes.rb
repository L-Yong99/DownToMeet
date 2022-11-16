Rails.application.routes.draw do
  devise_for :users
  root to: "events#index"
  resources :users do
    # resources :events, only: [:index, :new, :show, :create , :destroy]
    member do
      get 'events', to: 'events#hosted_event'
      # get 'events/:id', to: 'events#hosted_event_detail', as: :hosted_event_detail
      post 'events/:id', to: 'events#hosted_event_patch'
      # get 'events/new', to: 'events#new'
      # post 'events/create', to: 'events#create'
    end
    resources :attendances, only: [:index, :show, :create, :destroy]
  end
  resources :attendances, only: [:destroy]
  resources :events, only: [:index, :show, :destroy, :new, :create]

end
