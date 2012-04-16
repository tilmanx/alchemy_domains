source "http://rubygems.org"

gemspec

group :test do
	gem 'database_cleaner'
	gem "capybara"
	gem "fuubar"
	gem 'sqlite3'
	gem 'factory_girl_rails', '1.4.0'
end

group :development do
	gem "alchemy_cms", "~> 2.1.9"
	gem "rspec-rails", "~> 2.7"
	gem 'guard-rspec'
	gem 'guard-spork'
	#gem 'growl_notify'
	if !ENV["CI"]
		gem 'ruby-debug-base19', '~> 0.11.26', :platform => :ruby_19
		gem 'linecache19', '~> 0.5.13', :platform => :ruby_19
		gem 'ruby-debug19', '~> 0.11.6', :require => 'ruby-debug', :platform => :ruby_19
		gem 'ruby-debug', :platform => :ruby_18
	end
end
