Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#index'
  resources :games, only: [:new, :show, :create, :index, :update] do
    resources :pieces, only: [:show, :update]
  end
  resources :games do
    patch :active, on: :member
  end
end
