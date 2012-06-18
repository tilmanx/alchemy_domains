AlchemyDomains::Engine.routes.draw do
  namespace :admin do
    resources :domains
    resources :localizations, :only => [:update]
  end
end
