Rails.application.routes.draw do
  get 'attendances/index'
  get 'attendances/show'
  get 'attendances/destroy'
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/create'
  get 'users/destroy'
  devise_for :users
  root to: "events#index"
  resources :users do
    resources :events, only: [:index, :new, :show, :create , :destroy]
    resources :attendances, only: [:index, :show, :destroy]
  end

  resources :events, only: [:index, :show]
end
