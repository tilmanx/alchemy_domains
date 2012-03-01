module Alchemy
	class Domain < ActiveRecord::Base
		self.table_name = "alchemy_domains"
		has_many :languages, :source => "alchemy_languages", :through => :localizations
		validates :subdomain, :presence => true
		validates :tld, :presence => true
	end
end
