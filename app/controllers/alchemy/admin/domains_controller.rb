class Alchemy::Admin::DomainsController < Alchemy::Admin::ResourcesController
	def new
		@domain = Alchemy::Domain.new
		@languages = Alchemy::Language.published.all
		render :layout => !request.xhr?
	end

	def create
		@domain = Alchemy::Domain.new(params[:domain])
		@domain.save
		render_errors_or_redirect(
			@domain,
			admin_domains_path,
			"created"
		)
	end
end
