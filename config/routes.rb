ZombieBackend::Application.routes.draw do
  namespace :api, path: '/', constraints: { subdomain: 'api' } do
    resources :zombies, only: [:index, :show]
  end
end
