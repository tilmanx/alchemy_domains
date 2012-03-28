module AlchemyDomains
	class Domain < ActiveRecord::Base
		set_table_name :alchemy_domains
		has_many :localizations, :dependent => :destroy
		has_many :languages, :through => :localizations
		accepts_nested_attributes_for :localizations, :allow_destroy => true

		validates_presence_of :hostname
		validates_uniqueness_of :hostname
		validates_presence_of :default, :message => "Es muss eine Standard Domain geben", :if => proc { |m| m.default_changed? && m.default_was == true }
		# locahost is not valid, so we cant validate the format like that.
		#validates_format_of :hostname, :with => /^[a-z\d]+([\-\.][a-z\d]+)*\.[a-z]{2,6}/
		validates_format_of :hostname, :with => /^[a-z\d]+([\-\.][a-z\d]+)/

		before_create :set_to_default, :if => proc { |m| Domain.default.blank? && self.default == false }
		before_save :remove_old_default, :if => proc { |m| m.default_changed? && m != Domain.default }

		def default_localization
			self.localizations.where(:default_for_domain => true).first
		end

		def default_language
			default_localization.language if default_localization.present?
		end

		def default_language_name
			default_language.name if default_language.present?
		end

		def self.default
			Domain.find_by_default(true)
		end

	private

		def set_to_default
			self.default = true
		end

		def remove_old_default
			domain = Domain.default
			return true if domain.nil?
			domain.update_attribute(:default, false)
		end

	end
end
