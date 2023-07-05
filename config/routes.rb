Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  resources :users do
    resources :searches, only: [:index]
    resources :dashboards, only: [:index]
  end
  get 'users/:id/personal_information_edit', to: 'users#personal_information_edit', as: 'user_personal_information_edit'
  resources :locations do
    resources :incomes do
      get 'monthly_incomes', on: :collection
    end
    resources :expenses do
      get 'monthly_expenses', on: :collection
    end
  end
end
