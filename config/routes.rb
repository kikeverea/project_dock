Rails.application.routes.draw do
  resources :projects do
    get :config, on: :member, action: :config_attr
  end

  resources :projects, only: [] do
    resources :activities, shallow: true do
      scope :interaction do
        get "/", to: "activities#generating_interaction", as: :generating_interaction
      end
    end
  end

  resources :activities, only: [] do
    resources :tasks, shallow: true do
      post :batch, on: :collection
    end
  end

  resources :tasks, only: :index do
    resources :task_comments,
      path: "comments",
      as: "comments",
      shallow: true do
      get :cancel_edit, on: :member
    end

    resources :documents,
      only: %i[ create destroy ],
      controller: :task_documents
  end

  resources :phone_numbers
  resources :emails
  resources :tags
  resources :clients
  resources :users do
    get :profile, on: :collection
  end

  ## Auth
  resource :session, only: %i[ new create destroy ]
  resources :passwords, param: :token, only: %i[ new create edit update ]

  get "/upload", to: "clients#index", as: :upload_tmp_file

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