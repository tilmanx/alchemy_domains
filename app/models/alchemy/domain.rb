class Alchemy::Domain < ActiveRecord::Base
	self.table_name = "alchemy_domains"
	has_many :localizations
	has_many :languages, :through => :localizations
	accepts_nested_attributes_for :localizations

	validates :subdomain, :presence => true
	validates :tld, :presence => true

	def name
		return "#{self.subdomain}.#{self.tld}"
	end
end
