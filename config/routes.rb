Rails.application.routes.draw do
  root to: 'cocktails#index'

  resources :cocktails
  resources :ingredients, except: :show
  resources :recipe_items
  resources :units, except: :show
  resources :ingredient_categories, except: :show
  resources :garnishes, except: :show

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
