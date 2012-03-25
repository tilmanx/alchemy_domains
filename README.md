#AlchemyDomains [![Build Status](https://secure.travis-ci.org/[magiclabs]/[alchemy_domains].png)](http://travis-ci.org/[magiclabs]/[alchemy_domains])

### This gem extends Alchemy CMS with a Localization/Domain management.
If your website is multilingual and the provided languages should depend on the requested (sub)domain, this gem is what you need.


1.) You just need to require it in your `Gemfile`

    gem 'alchemy_domains'

2.) bundle all dependencies

    bundle install

3.) Then you need to mount it in your application´s `routes.rb`

    mount AlchemyDomains::Engine => '/'

4.) Copy the migrations to your application

    rake alchemy_domains:install:migrations

5.) Migrate the database

    rake db:migrate

Ready!
