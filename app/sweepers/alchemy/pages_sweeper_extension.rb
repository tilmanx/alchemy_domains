# encoding: UTF-8
# Extending Alchemy::Page

module Alchemy
  PagesSweeper.class_eval do

    def expire_page(page)
      return if page.do_not_sweep
      page.language.domains.each do |domain|
        expire_action(page.cache_key(OpenStruct.new(:host => domain.hostname)))
      end
    end

  end
end

