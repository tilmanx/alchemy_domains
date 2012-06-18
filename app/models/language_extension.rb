# encoding: UTF-8
# Extending Alchemy::Language

module Alchemy
  Language.class_eval do
    has_many :localizations, :dependent => :destroy, :class_name => "AlchemyDomains::Localization"
    has_many :domains, :through => :localizations, :class_name => "AlchemyDomains::Domain"

    scope :current_domain, lambda{ |domain_id| includes(:localizations).where("alchemy_localizations.domain_id" => domain_id) }
  end
end
