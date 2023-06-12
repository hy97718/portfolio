Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :users
end
