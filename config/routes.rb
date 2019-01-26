Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace  :api do
    namespace :v1 do
      namespace :customers do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
      end
      resources :customers, only: [:index, :show]
      
      namespace :merchants do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random', to: 'random#show'
        get 'most_revenue', to: 'most_revenue#index'
        get 'most_items', to: 'most_items#index'
        get 'revenue', to: 'revenue#index'
      end
      resources :merchants, only: [:index, :show] do
        scope module: :merchants do
          get 'revenue', to: 'revenue#show'
          get 'favorite_customer', to: 'favorite_customer#show'
          resources :items, only: [:index]
          resources :invoices, only: [:index]
        end
      end
      
      namespace :invoices do
        get 'find', to: 'search#show'
        get 'find_all', to: 'search#index'
      end
      resources :invoices, only: [:index, :show]
    end
  end
end
