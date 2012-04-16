$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "alchemy_domains/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "alchemy_domains"
  s.version     = AlchemyDomains::VERSION
  s.authors     = ["Robin Böning"]
  s.email       = ["rb@magiclabs.de"]
  s.homepage    = "http://magiclabs.de"
  s.summary     = "This gem adds the functionality for managing domains in Alchemy CMS."
  s.description = "This gem adds domains and associats them with languages. Your website can provide certain languages depending on the requested domain."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"
  s.add_dependency(%q<alchemy_cms>, ["~> 2.1.9"])

  s.add_development_dependency(%q<sqlite3>)

end
