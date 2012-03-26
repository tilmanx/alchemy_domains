# encoding: UTF-8
# Extending Alchemy::Page

module Alchemy
	Page.class_eval do
		scope :current_domain, lambda{ |domain_id| includes(:language => :localizations).where('alchemy_localizations.domain_id' => domain_id) }
	end
end
