# encoding: UTF-8
# Extending Alchemy::Page

module Alchemy
	Page.class_eval do
		scope :current_domain, lambda{ |domain_id| includes(:language => :localizations).where('alchemy_localizations.domain_id' => domain_id) }

		def self.cache_path(params, request)
			"alchemy/#{request.host}/#{params[:lang]}/#{params[:urlname]}".gsub(/\/\//, '/')
		end
	end
end
