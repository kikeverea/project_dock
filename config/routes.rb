Rails.application.routes.draw do
  resources :projects do
    get :config, on: :member, action: :config_attr
  end

  resources :projects, only: [] do
    resources :documents, controller: :project_documents, shallow: true
    resources :tasks, except: :index, controller: :tasks
    resources :activities, shallow: true do
      scope :interaction do
        get "/", to: "activities#generating_interaction", as: :generating_interaction
      end
    end
    resources :comments, except: :index, controller: :comments do
      get :reply, to: "comments#new", as: :new_reply
      get '/cancel_form', to: "comments#cancel_form", on: :collection
    end
  end

  resources :activities, only: [] do
    resources :tasks, except: :index, controller: :tasks do
      post :batch, on: :collection
    end
    resources :comments, except: :index, controller: :comments do
      get :reply, to: "comments#new", as: :new_reply
      get '/cancel_form', to: "comments#cancel_form", on: :collection
    end
  end

  resources :tasks do
    resources :comments, except: :index, controller: :comments do
      get :reply, to: "comments#new", as: :new_reply
      get '/cancel_form', to: "comments#cancel_form", on: :collection
    end
    resources :documents, only: %i[ create destroy ], controller: :task_documents
  end

  resources :comments, only: %i[ create update ] do
    resources :reply, controller: :comments, only: %i[ new create ], on: :member
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