AlchemyDomains::Engine.routes.draw do
	namespace :admin do
		resources :domains
	end
end
