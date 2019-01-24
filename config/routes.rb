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
        get 'most_revenue', to: 'most_revenue#index'
      end
      resources :merchants, only: [:index] do
        scope module: :merchants do
          get 'revenue', to: 'revenue#index'
        end
      end
    end
  end
end
