Rails.application.routes.draw do
  resources :projects
  resources :phone_numbers
  resources :emails
  resources :tags
  resources :logs
  resources :activities
  resources :clients
  resources :tasks
  resources :interactions
  resources :documents
  resources :users do
    get :profile, on: :collection
  end

  ## Auth
  resource :session, only: %i[ new create destroy ]
  resources :passwords, param: :token, only: %i[ new create edit update ]

### Global
  get "/revoked", to:"revoked#revoked", as: :revoked
  root to: "projects#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500
  # Can be used by load balancers and uptime monitors to verify that the app is live
  get "up", to: "rails/health#show", as: :rails_health_check

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end