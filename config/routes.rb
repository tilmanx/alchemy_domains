Alchemy::Engine.routes.append do
	namespace :admin do
		resources :domains
	end
end
