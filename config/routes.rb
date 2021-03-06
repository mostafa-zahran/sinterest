Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
  namespace :v1 do
    resources :users
    resources :tracks
    resources :playlists
    post 'sessions' => 'sessions#create'
    delete 'sessions' => 'sessions#destroy'
  end
end
