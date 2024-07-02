Rails.application.routes.draw do
  root to: 'cocktails#index'

  resources :cocktails, only: [:index, :show] do
    member do
      post :show_scaled
    end
  end

  # revise_auth
  scope module: :revise_auth do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
  end

  authenticated do
    namespace :admin do
      resources :cocktails, except: [:index, :show]
      resources :garnishes, except: :show
      resources :ingredients, except: :show
      resources :units, except: :show
      resources :ingredient_categories, except: :show
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
