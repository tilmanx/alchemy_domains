module AlchemyDomains
  class Engine < Rails::Engine

    engine_name "alchemy_domains"
    isolate_namespace AlchemyDomains

    # Registering module in Alchemy CMS
    initializer 'alchemy_domains.register_as_alchemy_module' do
      Alchemy::Modules.register_module(YAML.load_file(File.join(File.dirname(__FILE__), '../..', 'config/module_definition.yml')))
    end

    # Loading authorization rules and register them to auth engine instance
    initializer 'alchemy_domains.add_authorization_rules' do
      Alchemy::AuthEngine.get_instance.load(File.join(File.dirname(__FILE__), '../..', 'config/authorization_rules.rb'))
    end

    # Loading all alchemy core extensions found in app folder.
    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_extension.rb")) do |e|
        Rails.env.production? ? require(e) : load(e)
      end
    end

  end
end
