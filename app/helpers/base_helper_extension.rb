module Alchemy
  BaseHelper.class_eval do

    def multi_language?
      Alchemy::Language.current_domain(session[:domain_id]).published.count > 1
    end

  end
end
