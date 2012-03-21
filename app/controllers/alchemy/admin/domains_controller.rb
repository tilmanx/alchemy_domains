module Alchemy
	module Admin
		class DomainsController < Alchemy::Admin::ResourcesController

			def new
				@domain = Domain.new
				@languages = Language.published.all
				@languages.map { |l| @domain.localizations.build(:language => l) }
				render :layout => !request.xhr?
			end

			def edit
				@domain = Domain.find(params[:id])
				@languages = Language.published.all
				(@languages - @domain.languages).map { |l| @domain.localizations.build(:language => l) }
				render :layout => !request.xhr?
			end

			def update
				params[:domain][:localizations_attributes].map do |k, v|
					if v[:language_id] == "0"
						v[:_destroy] = '1'
						v.delete(:language_id)
					end
				end
				@domain = Domain.find(params[:id])
				@domain.update_attributes(params[:domain])
				render_errors_or_redirect(
					@domain,
					url_for({:action => :index}),
					flash_notice_for_resource_action
				)
			end

			def create
				params[:domain][:localizations_attributes].delete_if { |k, v| v[:language_id] == "0" }
				params[:domain][:localizations_attributes].first[1][:default_for_domain] = true
				@domain = Domain.new(params[:domain])
				@domain.save
				render_errors_or_redirect(
					@domain,
					admin_domains_path,
					"created"
				)
			end

		end
	end
end
