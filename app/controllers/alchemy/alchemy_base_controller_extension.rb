# encoding: UTF-8
# Extending Alchemy::BaseController

module Alchemy
  BaseController.class_eval do

    prepend_before_filter :set_domain

    def multi_language?
      # This will check only the current requested domain and ignores other domains.
      Language.current_domain(session[:domain_id]).published.count > 1
    end

  private

    def set_domain
      @domain = AlchemyDomains::Domain.find_by_hostname(request.host)
      if @domain
        session[:domain_id] ||= @domain.id
      elsif default_domain = AlchemyDomains::Domain.default
        redirect_to request.protocol + default_domain.hostname, :status => 301
        return false
      else
        # No Domains found. We need to create the requested.
        @domain = AlchemyDomains::Domain.create!(:hostname => request.host)
        @domain.localizations.create!(:language => Language.get_default)
        session[:domain_id] = @domain.id
      end
    end

    # Sets the language for rendering pages in pages controller
    def set_language
      if params[:lang].blank? and session[:language_id].blank?
        set_language_to_default
      elsif !params[:lang].blank?
        set_language_from(params[:lang])
        ::I18n.locale = params[:lang]
      end
    end

    # Sets the language from the given params
    def set_language_from(language_code_or_id)
      if language_code_or_id.is_a?(String) && language_code_or_id.match(/^\d+$/)
        language_code_or_id = language_code_or_id.to_i
      end
      case language_code_or_id.class.name
        when "String"
          @language = Language.current_domain(session[:domain_id]).find_by_code(language_code_or_id)
        when "Fixnum"
          @language = Language.find(language_code_or_id)
      end
      store_language_in_session(@language)
    end

    # Sets the language to the domain´s default language
    def set_language_to_default
      @language = AlchemyDomains::Domain.find(session[:domain_id]).default_language
      if @language
        store_language_in_session(@language)
      else
        raise "No Default Language for requested Domain found! Did you run `rake alchemy_domains:add:domain` task?"
      end
    end

  end
end
