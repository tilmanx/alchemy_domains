class Alchemy::Localization < ActiveRecord::Base
	self.table_name = "alchemy_localizations"
	belongs_to :domain
	belongs_to :language
end
