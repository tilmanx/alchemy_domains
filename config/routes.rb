Alchemy::Engine.routes.append do
	namespace :admin do
		resources :domains
		resources :localizations
	end
end

# AlchemyDomains::Engine.routes.draw do
# 	namespace :admin do
# 		resources :domains
# 		resources :localizations
# 	end
# end
# 	