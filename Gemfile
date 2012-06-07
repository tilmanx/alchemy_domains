source "http://rubygems.org"

gemspec

group :test do
  gem 'database_cleaner'
  gem "capybara"
  gem 'sqlite3'
  gem 'factory_girl_rails', '1.7.0'
end

group :development do
  gem "rspec-rails", "~> 2.7"
  gem 'guard-rspec'
  gem 'guard-spork'
  #gem 'growl_notify'
  if !ENV["CI"]
    gem 'debugger'
  end
end
