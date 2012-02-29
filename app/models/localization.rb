class Localization < ActiveRecord::Base
	self.table_name = "alchemy_localizations"
	belongs_to :domain
	belongs_to :language, :class_name => "alchemy_languages"
end