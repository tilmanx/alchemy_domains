module AlchemyDomains
	class Domain < ActiveRecord::Base
		set_table_name :alchemy_domains
		has_many :localizations, :dependent => :destroy
		has_many :languages, :through => :localizations
		accepts_nested_attributes_for :localizations, :allow_destroy => true

		validates_presence_of :hostname
		validates_format_of :hostname, :with => /^[a-z\d]+([\-\.][a-z\d]+)*\.[a-z]{2,6}/

		def default_localization
			self.localizations.where(:default_for_domain => true).first
		end

		def default_language
			default_localization.language if default_localization.present?
		end

		def default_language_name
			default_language.name if default_language.present?
		end

		def self.find_by_hostname_or_default(hostname)
			Domain.find_by_hostname(hostname) || Domain.default # || raise "No Default Domain Found!"
		end

		def self.default
			Domain.find_by_default(true)
		end

	end
end
