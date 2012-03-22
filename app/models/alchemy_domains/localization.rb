module AlchemyDomains
	class Localization < ActiveRecord::Base
		set_table_name :alchemy_localizations
		belongs_to :domain
		belongs_to :language, :class_name => "Alchemy::Language"

		before_create :set_to_default_for_domain, :if => proc { |m| m.domain.default_localization.blank? && self.default_for_domain == false }
		before_save :remove_old_default, :if => proc { |m| m.default_for_domain_changed? && m != Localization.default_for_domain(domain_id) }

		scope :domain_languages

		def self.default_for_domain(domain_id)
			find_by_default_for_domain_and_domain_id(true, domain_id)
		end

	private

		def set_to_default_for_domain
			self.default_for_domain = true
		end

		def remove_old_default
			localization = Localization.default_for_domain(domain_id)
			return true if localization.nil?
			localization.update_attribute(:default_for_domain, false)
		end

	end
end
