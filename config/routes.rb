Rails.application.routes.draw do
  resources :artist_genres
  resources :artist_tracks
  resources :genres
  resources :artists
  resources :user_tracks
  resources :tracks
  resources :albums

  namespace :api do
    namespace :v1 do
      get '/login', to: "users#spotify_create"
      post '/user', to: "users#create"
      get '/get-library', to: "users#get_library"
      get '/tracks', to: "tracks#index"
      get '/tracks/recently-played', to: "tracks#get_recently_played"
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
