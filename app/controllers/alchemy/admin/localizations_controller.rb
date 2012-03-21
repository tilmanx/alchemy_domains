module Alchemy
	module Admin
		class LocalizationsController < Alchemy::Admin::ResourcesController

			def new
				@domain = Localization.new
				@domains = Domain.all
				@languages = Language.published.all
				render :layout => !request.xhr?
			end

			def create
				@localization = Localization.new(params[:localization])
				@localization.save
				render_errors_or_redirect(
					@localization,
					admin_localizations_path,
					"created"
				)
			end

			def update
				@localization = Localization.find(params[:id])
				@localization.update_attributes(params[:localization])
				render_errors_or_redirect(
					@localization,
					admin_domains_path,
					"updated"
				)
			end

		end
	end
end
