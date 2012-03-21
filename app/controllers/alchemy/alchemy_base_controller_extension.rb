# encoding: UTF-8
# Extending Alchemy::BaseController

module Alchemy
	BaseController.class_eval do

		prepend_before_filter :set_domain

	private

		def set_domain
			session[:domain_id] ||= Domain.find_by_hostname_or_default(request.host).id
		end

		# Sets the language for rendering pages in pages controller
		def set_language
			if params[:lang].blank? and session[:language_id].blank?
				set_language_to_default
			elsif !params[:lang].blank?
				set_language_from(params[:lang])
				::I18n.locale = params[:lang]
			end
		end

		def set_language_from(language_code_or_id)
			if language_code_or_id.is_a?(String) && language_code_or_id.match(/^\d+$/)
				language_code_or_id = language_code_or_id.to_i
			end
			case language_code_or_id.class.name
				when "String"
					@language = Language.find_by_code(language_code_or_id)
				when "Fixnum"
					@language = Language.find(language_code_or_id)
			end
			store_language_in_session(@language)
		end

		def set_language_to_default
			@language = Language.get_default
			if @language
				store_language_in_session(@language)
			else
				raise "No Default Language found! Did you run `rake alchemy:db:seed` task?"
			end
		end

	end
end
