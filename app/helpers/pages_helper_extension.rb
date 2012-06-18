# encoding: UTF-8
# Extending Alchemy::PagesHelper

module Alchemy
  PagesHelper.class_eval do

    def language_switcher(options={})
      default_options = {
        :linkname => :name,
        :spacer => "",
        :link_to_public_child => configuration(:redirect_to_public_child),
        :link_to_page_with_layout => nil,
        :show_title => true,
        :reverse => false,
        :as_select_box => false,
        :show_flags => false
      }
      options = default_options.merge(options)
      if multi_language?
        language_links = []
        pages = (options[:link_to_public_child] == true) ? Page.language_roots.current_domain(session[:domain_id]) : Page.public_language_roots.current_domain(session[:domain_id])
        return nil if (pages.blank? || pages.length == 1)
        pages.each_with_index do |page, i|
          if(options[:link_to_page_with_layout] != nil)
            page_found_by_layout = Page.current_domain(session[:domain_id]).where(:page_layout => options[:link_to_page_with_layout].to_s, :language_id => page.language_id)
          end
          page = page_found_by_layout || page
          page = (options[:link_to_public_child] ? (page.first_public_child.blank? ? nil : page.first_public_child) : nil) if !page.public?
          if !page.blank?
            active = session[:language_id] == page.language.id
            linkname = page.language.label(options[:linkname])
            if options[:as_select_box]
              language_links << [linkname, show_page_url(:urlname => page.urlname, :lang => page.language.code)]
            else
              language_links << link_to(
                "#{content_tag(:span, '', :class => "flag") if options[:show_flags]}#{ content_tag(:span, linkname)}".html_safe,
                alchemy.show_page_path(:urlname => page.urlname, :lang => page.language.code),
                :class => "#{(active ? 'active ' : nil)}#{page.language.code} #{(i == 0) ? 'first' : (i==pages.length-1) ? 'last' : nil}",
                :title => options[:show_title] ? Alchemy::I18n.t("alchemy.language_links.#{page.language.code}.title", :default => page.language.name) : nil
              )
            end
          end
          # when last iteration and we have just one language_link,
          # we dont need to render it.
          if (i==pages.length-1) && language_links.length == 1
            return nil
          end
        end
        return nil if language_links.empty? || language_links.length == 1
        language_links.reverse! if options[:reverse]
        if options[:as_select_box]
          return select_tag(
            'language',
            options_for_select(
              language_links,
              show_page_url(:urlname => @page.urlname, :lang => @page.language.code)
            ),
            :onchange => "window.location=this.value"
          )
        else
          raw(language_links.join(options[:spacer]))
        end
      else
        nil
      end
    end
    alias_method :language_switches, :language_switcher

  end
end
