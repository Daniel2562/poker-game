require 'api_constraints.rb'

Rails.application.routes.draw do
  
  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  scope module: :api, defaults: { format: :json }  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1,
                                                       default: true) do

      post   'promo/:promo_code/apply'    => 'users#apply_promo'    # DONE
      get    'promo/:promo_code/check'    => 'users#check_promo'    # DONE
      get    'users/me'             => 'users#me'                   # DONE
      get    'users/pros'           => 'users#pros'                 # DONE
      post   'users/login'          => 'users#login'                # DONE
      delete 'users/logout'         => 'users#logout'               # DONE
      post   'users/reset_password' => 'users#reset_password'       # DONE
      resources :users, only: [:create, :destroy, :update]          # DONE

      resources :sessions do                                        # DONE
        resources :hands, only: [:create, :index]                   # DONE
      end

      resources :hands, only: [:destroy, :update, :show] do         # DONE
        resources :requests, only: [:index, :create]                # DONE
      end

      get     'users/:id/requests/incoming'   => 'requests#index_incoming_to'    # DONE
      get     'users/:id/requests/created'   => 'requests#index_created_by'    # DONE
      get     'requests/incoming'   => 'requests#index_incoming'    # DONE
      get     'requests/created'    => 'requests#index_created'     # DONE
      resources :requests, only: [:show, :destroy] do               # DONE
        resources :comments, only: [:create]                        # DONE
      end
      patch   'requests/:id/view'    => 'requests#view'             # DONE
      patch   'requests/:id/resolve' => 'requests#resolve'          # DONE
      patch   'requests/:id/accept'  => 'requests#accept'           # DONE

      resources :comments, only: [:destroy, :update]                # DONE


      patch  'users/:id/migrate'    => 'users#migrate'              # DONE
      patch  'sessions/:id/migrate_timestamps'    => 'sessions#migrate_timestamps'
      patch  'hands/:id/migrate_timestamps'    => 'hands#migrate_timestamps'
      patch  'requests/:id/migrate_timestamps'    => 'requests#migrate_timestamps'
      patch  'hands/:id/migrate'    => 'hands#migrate'              # DONE

    end
  end

  get 'users/confirm/:token',        to: 'users#confirm', as: 'users_confirm'
  get 'users/confirm_reset/:token',  to: 'users#confirm_reset', as: 'users_confirm_reset'
  get 'privacy',                     to: 'pages#privacy'
  get 'terms',                       to: 'pages#terms'

  root :to => "pages#terms"

end
