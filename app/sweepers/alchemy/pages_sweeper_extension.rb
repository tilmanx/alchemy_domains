# encoding: UTF-8
# Extending Alchemy::Page

module Alchemy
  PagesSweeper.class_eval do

    def expire_page(page)
      return if page.do_not_sweep
      # TODO: We should change this back to expire_action after Rails 3.2 was released.
      # expire_action(
      #   alchemy.show_page_url(
      #     :urlname => page.urlname_was,
      #     :lang => multi_language? ? page.language_code : nil
      #   )
      # )
      # Temporarily fix for Rails 3 bug
      return if alchemy.nil?
      page.language.domains.each do |domain|
        expire_fragment(ActionController::Caching::Actions::ActionCachePath.new(
          self,
          alchemy.show_page_url(
            :urlname => page.urlname_was,
            :lang => domain.languages.count > 1 ? page.language_code : nil,
            :host => domain.hostname
          ),
          false
        ).path)
      end
    end

  end
end

